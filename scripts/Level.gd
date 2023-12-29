extends Node3D
class_name GDLevel

var selected_tree_type: GDTreeType;
var selected_tree_entity: GDTree;
var HUD: GDHUD;
var camera: Camera3D;
var trees: Node3D;
const TERRAIN_EDGE_LENGTH: int = 100;
var POS_TO_GRID_MULT: float = GDConsts.CELL_COUNT_PER_EDGE * 1.0 / TERRAIN_EDGE_LENGTH;
var is_cursor_on_ui: bool = false;
var grid: GDGrid;
var level_settings: GDLevelSettings;
var winning_conditions: GDWinningConditions;
var air: GDAir;
var plant_count: Dictionary = {};
enum HOVER_MODE {None, Plant, Bulldoze};
var hover_mode: HOVER_MODE = HOVER_MODE.None;

func _base_ready():
  assert(level_settings, "Level should set level_settings before calling _base_ready!");
  assert(winning_conditions, "Level should set winning_conditions before calling _base_ready!");
  camera = get_node("Camera/Camera3D");
  trees = get_node("Trees");
  HUD = get_node("HUD");
  HUD.connect("tree_type_selected", _tree_type_selected);
  HUD.connect("bulldozer_selected", _bulldozer_selected);
  var gameView = HUD.get_node("Game")
  gameView.connect("mouse_entered", _hud_mouse_entered);
  gameView.connect("mouse_exited", _hud_mouse_exited);
  var secondTimer: Timer = get_node("SecondTimer");
  secondTimer.connect("timeout", _on_second_callback.bind(secondTimer.get_wait_time()));
  var replenishTimer: Timer = get_node("ReplenishTimer");
  replenishTimer.connect("timeout", _on_replenish_callback.bind(replenishTimer.get_wait_time()));
  _init_grid_map();
  air = GDAir.new(level_settings);
  HUD.show_air_info(air);

func _init_grid_map():
  grid = GDGrid.new(level_settings, get_node('Terrain'));
  var cam: GDCamera = camera.get_parent();
  cam.terrain_size  = GDConsts.CELL_COUNT_PER_EDGE / grid.pos_to_grid_mult;

func _on_level_won():
  pass

func _on_second_callback(delta: float):
  # process all existing trees
  for tree_node in trees.get_children():
    var tree: GDTree = tree_node;
    var grid_pos = grid.world_pos_to_grid(tree.position);
    tree.grow(grid.get_cell(grid_pos), air, delta * GlobalSettings.time_coef, GlobalSettings.growth_coef);
  air.replenish(level_settings, delta * GlobalSettings.time_coef);
  HUD.show_air_info(air);
  if winning_conditions.player_won(self):
    print('Player has passed this level!');
    _on_level_won();

func _on_replenish_callback(delta: float):
  grid.replenish(level_settings, delta);


func _hud_mouse_entered():
  if selected_tree_entity:
    selected_tree_entity.show()
    is_cursor_on_ui = false;

func _hud_mouse_exited():
  if selected_tree_entity:
    selected_tree_entity.hide()
    is_cursor_on_ui = true;

func _base_physics_process():
  _update_selected_tree_entity();

func _bulldozer_selected():
  _unselect_tree_type();
  hover_mode = HOVER_MODE.Bulldoze;

func _tree_type_selected(tree_type: GDTreeType):
  hover_mode = HOVER_MODE.Plant;
  var pos: Vector3 = Vector3.ZERO;
  if selected_tree_entity:
    pos = selected_tree_entity.position;
    selected_tree_entity.get_parent().remove_child(selected_tree_entity);
    selected_tree_entity.queue_free();
  selected_tree_type = tree_type;
  selected_tree_entity = selected_tree_type.mesh.instantiate();
  # TODO: semi transparent (set albedo.alpha of SpatialMaterial of MeshInstance(s))
  selected_tree_entity.position = pos;
  add_child(selected_tree_entity);

func _update_selected_tree_entity():
  if is_cursor_on_ui:
    return
  var result = GDUtils.cast_ray_from_camera(camera, GDConsts.PHYSICS_LAYERS.Terrain);
  var is_hovering_valid: bool = false;
  if result:
    var collider = result['collider'];
    var parent = collider.get_parent();
    # TODO: can also do this via physics materials
    # TODO: this'll change when water plants are added
    if parent.name == 'water':
      is_hovering_valid = false;
    else:
      is_hovering_valid = true;
    var grid_pos = grid.world_pos_to_grid(result.position);
    HUD.show_grid_info(grid_pos.x, grid_pos.y, grid.get_cell(grid_pos));
  else:
    HUD.show_grid_info(-1, -1, null);
  if selected_tree_entity:
    if is_hovering_valid:
      selected_tree_entity.position = result.position;
      selected_tree_entity.show();
    else:
      selected_tree_entity.hide();

func _input(event):
  if event is InputEventMouseButton and event.pressed and event.button_index == 1:
    if hover_mode == HOVER_MODE.Plant and selected_tree_entity.is_visible():
      _plant_tree(selected_tree_type, selected_tree_entity.position);
    elif hover_mode == HOVER_MODE.Bulldoze:
      _bulldoze();
  elif event is InputEventMouseButton and event.pressed and event.button_index == 2:
    if hover_mode == HOVER_MODE.Plant:
      _unselect_tree_type();
    hover_mode = HOVER_MODE.None;

func _unselect_tree_type():
  if selected_tree_entity:
    selected_tree_entity.queue_free();
    selected_tree_entity = null;
    selected_tree_type = null;

func _bulldoze():
  var result = GDUtils.cast_ray_from_camera(camera, GDConsts.PHYSICS_LAYERS.Plant);
  if not result:
    return;
  var collider = result['collider'];
  var tree = collider.get_parent().get_parent().get_parent();
  assert(tree is GDTree);
  plant_count[tree.tree_type.name] -= 1;
  tree.queue_free();

func _plant_tree(tree_type: GDTreeType, pos: Vector3):
  var new_entity: GDTree = tree_type.mesh.instantiate();
  new_entity.position = pos;
  new_entity.rotation = Vector3(0, 2 * PI * randf(), 0);
  new_entity.tree_type = tree_type;
  plant_count[tree_type.name] = plant_count.get(tree_type.name, 0) + 1
  trees.add_child(new_entity)

