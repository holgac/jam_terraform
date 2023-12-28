extends VBoxContainer

class_name GDHUD;

var trees_hbox: HBoxContainer;
@onready var grid_info: Label = get_node("Game/GridInfo");
@onready var air_info: Label = get_node("Game/AirInfo");

signal tree_type_selected(tree_type: GDTreeType);
signal bulldozer_selected;

func show_air_info(air: GDAir):
  var air_contents: String = str('FPS: ', Engine.get_frames_per_second(), '\n');
  var normalized: Dictionary = air.get_normalized();
  for gas_id in range(GDConsts.GAS.COUNT):
    air_contents += str(GDConsts.GAS_NAMEC[gas_id], ': ',
        str(100 * normalized[GDConsts.GAS_NAME[gas_id]]).pad_decimals(2), '%\n');
  air_info.set_text(air_contents);

func show_grid_info(grid_x: int, grid_y: int, grid: GDGrid):
  if not grid:
    grid_info.set_text('Hover over a grid to view its contents')
    return

  # constructing a string each frame is bad.
  # can check if prev call used the same x, y and skip update
  # maybe use format string instead?
  var grid_contents: String = '';
  for mat_id in range(GDConsts.MATERIAL.COUNT):
    grid_contents += str(GDConsts.MATERIAL_NAMEC[mat_id], ': ',
        str(grid.contents[GDConsts.MATERIAL_NAME[mat_id]]).pad_decimals(4), '\n');
    
  grid_info.set_text(str(
    'Grid ', grid_x, ',', grid_y, '\n',
    grid_contents
    ));

# Called when the node enters the scene tree for the first time.
func _ready():
  trees_hbox = get_node("BottomBar/ScrollContainer/HBoxContainer");
  var selector_scene = preload("res://ui/TreeSelector.tscn");
  for tree_type in GlobalSettings.tree_types:
    var selector: GDTreeSelector = selector_scene.instantiate();
    selector.tree_type = tree_type;
    selector.connect("pressed", _on_tree_type_selected);
    trees_hbox.add_child(selector);
  get_node('BottomBar/ScrollContainer/HBoxContainer/Bulldozer').connect('pressed', _bulldozer_selected);
  get_node('Game/BackToMainMenu').connect('pressed', Session.goto_scene.bind(Session.MainMenuScene));

func _bulldozer_selected():
  bulldozer_selected.emit();

func _on_tree_type_selected(tree_type: GDTreeType):
  print("selected tree: ", tree_type.name)
  tree_type_selected.emit(tree_type);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass
