extends Node
class_name GDGlobalSettings

const time_coef: float = 0.5;
const growth_coef: float = 0.2;
const TREE_TYPES_JSON: String = "res://data/trees.json";
const TERRAIN_TYPES_JSON: String = "res://data/terrain.json";
var tree_types: Array[GDTreeType] = [];
var terrain_types: Dictionary;

# Called when the node enters the scene tree for the first time.
func _ready():
  _load_trees();
  _load_terrains();

func _load_terrains():
  var text = FileAccess.get_file_as_string(TERRAIN_TYPES_JSON);
  var json = JSON.parse_string(text);
  for data in json.keys():
    terrain_types[data] = json[data].duplicate();

func _load_trees():
  var text = FileAccess.get_file_as_string(TREE_TYPES_JSON);
  var json = JSON.parse_string(text);
  for data in json:
    tree_types.append(GDTreeType._from_json(data));
