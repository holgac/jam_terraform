extends VBoxContainer

class_name GDHUD;

var trees_hbox: HBoxContainer;
@onready var grid_info: Label = get_node("Game/GridInfo");
# var global_settings: GDGlobalSettings;

signal tree_type_selected(tree_type: GDTreeType);

func show_grid_info(grid_x: int, grid_y: int, grid: GDGrid):
	# constructing a string each frame is bad.
	# can check if prev call used the same x, y and skip update
	# maybe use format string instead?
	grid_info.set_text(str(
		'Grid ', grid_x, ',', grid_y, '\n',
		'Phosphorus: ', str(grid.phosphorus).pad_decimals(4), '\n',
		'Potassium: ', str(grid.potassium).pad_decimals(4), '\n',
		'Calcium: ', str(grid.calcium).pad_decimals(4), '\n'
		));

# Called when the node enters the scene tree for the first time.
func _ready():
	trees_hbox = get_node("BottomBar/ScrollContainer/HBoxContainer");
	var global_settings = get_tree().get_root().get_node("Level/GlobalSettings");
	var selector_scene = preload("res://ui/TreeSelector.tscn");
	for tree_type in global_settings.tree_types:
		var selector: GDTreeSelector = selector_scene.instantiate();
		selector.tree_type = tree_type;
		selector.connect("pressed", _on_tree_type_selected);
		trees_hbox.add_child(selector);
	

func _on_tree_type_selected(tree_type: GDTreeType):
	print("selected tree: ", tree_type.name)
	tree_type_selected.emit(tree_type);
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
