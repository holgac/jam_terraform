extends Node3D
class_name GDLevel

var selected_tree_type: GDTreeType;
var selected_tree_entity: GDTree;
var HUD: GDHUD;
var camera: Camera3D;
var trees: Node3D;
var RAY_LENGTH: int = 200;
const GRID_COUNT_PER_EDGE: int = 20;
const TERRAIN_EDGE_LENGTH: int = 100;
const POS_TO_GRID_MULT: float = GRID_COUNT_PER_EDGE * 1.0 / TERRAIN_EDGE_LENGTH;
var is_cursor_on_ui: bool = false;
var grids: Array[GDGrid] = [];
var level_settings: GDLevelSettings;
var air: GDAir;

@onready var global_settings: GDGlobalSettings = $GlobalSettings;

func _to_grid_array_coords(x: int, y: int):
	return y * GRID_COUNT_PER_EDGE + x;

func _world_pos_to_grid(pos: Vector3):
		var grid_x: int = int(pos.x * POS_TO_GRID_MULT);
		# -z because our map goes from 0 to -TERRAIN_EDGE_LENGTH in z coords
		var grid_y: int = int(-pos.z * POS_TO_GRID_MULT);
		return Vector2i(grid_x, grid_y);

func _base_ready():
	assert(level_settings, "Level should set level_settings before calling _base_ready!");
	camera = get_node("Camera/Camera3D");
	trees = get_node("Trees");
	HUD = get_node("HUD");
	HUD.connect("tree_type_selected", _tree_type_selected);
	var gameView = HUD.get_node("Game")
	gameView.connect("mouse_entered", _hud_mouse_entered);
	gameView.connect("mouse_exited", _hud_mouse_exited);
	var secondTimer: Timer = get_node("SecondTimer");
	secondTimer.connect("timeout", _on_second_callback);
	var replenishTimer: Timer = get_node("ReplenishTimer");
	replenishTimer.connect("timeout", _on_replenish_callback.bind(replenishTimer.get_wait_time()));
	for x in range(GRID_COUNT_PER_EDGE):
		for y in range(GRID_COUNT_PER_EDGE):
			grids.append(GDGrid.new(level_settings));
	air = GDAir.new(level_settings);
	HUD.show_air_info(air);

func _on_second_callback():
	# process all existing trees
	for tree_node in trees.get_children():
		var tree: GDTree = tree_node;
		var grid_pos = _world_pos_to_grid(tree.position);
		tree.grow(grids[_to_grid_array_coords(grid_pos.x, grid_pos.y)], air, global_settings.time_coef);
	air.normalize();
	air.replenish(level_settings, global_settings.time_coef);
	air.normalize();
	HUD.show_air_info(air);

func _on_replenish_callback(delta: float):
	for i in range(GRID_COUNT_PER_EDGE * GRID_COUNT_PER_EDGE):
		var grid: GDGrid = grids[i];
		grid.replenish(level_settings, global_settings.time_coef * delta);


func _hud_mouse_entered():
	print('mouse entered')
	if selected_tree_entity:
		selected_tree_entity.show()
		is_cursor_on_ui = false;

func _hud_mouse_exited():
	print('mouse exited')
	if selected_tree_entity:
		selected_tree_entity.hide()
		is_cursor_on_ui = true;

func _base_physics_process():
	_update_selected_tree_entity();

func _tree_type_selected(tree_type: GDTreeType):
	var position: Vector3 = Vector3.ZERO;
	if selected_tree_entity:
		position = selected_tree_entity.position;
		selected_tree_entity.get_parent().remove_child(selected_tree_entity);
		selected_tree_entity.queue_free();
	selected_tree_type = tree_type;
	selected_tree_entity = selected_tree_type.mesh.instantiate();
	# TODO: semi transparent (set albedo.alpha of SpatialMaterial of MeshInstance(s))
	selected_tree_entity.position = position;
	add_child(selected_tree_entity);

func _update_selected_tree_entity():
	if is_cursor_on_ui:
		return
	var space_state = get_world_3d().direct_space_state;
	var mousepos = get_viewport().get_mouse_position();

	var origin = camera.project_ray_origin(mousepos);
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH;
	var query = PhysicsRayQueryParameters3D.create(origin, end);
	query.collide_with_areas = true;

	# TODO: set coll mask; this'll intersect with other trees once (if?) their physics are imported
	var result = space_state.intersect_ray(query);
	var is_hovering_valid: bool = false;
	if result:
		var collider = result['collider'];
		var parent = collider.get_parent();
		# TODO: can also do this via physics materials
		if parent.name == 'water':
			is_hovering_valid = false;
		else:
			is_hovering_valid = true;
		var grid_x: int = int(result.position.x * POS_TO_GRID_MULT);
		# -z because our map goes from 0 to -TERRAIN_EDGE_LENGTH in z coords
		var grid_y: int = int(-result.position.z * POS_TO_GRID_MULT);
		var grid_pos = _world_pos_to_grid(result.position);
		HUD.show_grid_info(grid_pos.x, grid_pos.y,
			grids[_to_grid_array_coords(grid_pos.x, grid_pos.y)]);
	if selected_tree_entity:
		if is_hovering_valid:
			selected_tree_entity.position = result.position;
			selected_tree_entity.show();
		else:
			selected_tree_entity.hide();

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1 and
			selected_tree_entity and selected_tree_entity.is_visible()):
		var new_entity: GDTree = selected_tree_type.mesh.instantiate();
		new_entity.position = selected_tree_entity.position;
		new_entity.tree_type = selected_tree_type;
		trees.add_child(new_entity)
	elif (event is InputEventMouseButton and event.pressed and event.button_index == 2 and
			selected_tree_entity):
		selected_tree_entity.queue_free();
		selected_tree_entity = null;
		selected_tree_type = null;
