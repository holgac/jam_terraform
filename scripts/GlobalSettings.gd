extends Node
class_name GDGlobalSettings

@export var time_coef: float = 0.1;
@export var tree_types_json: String = "res://data/trees.json";
var tree_types: Array[GDTreeType] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_trees();

func _load_trees():
	var text = FileAccess.get_file_as_string(tree_types_json);
	var json = JSON.parse_string(text);
	for data in json:
		tree_types.append(GDTreeType._from_json(data));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
