extends Node
class_name GDGlobalSettings

@export var time_coef: float = 1;
var tree_types: Array[GDTreeType] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	tree_types.append(GDTreeType.new("slow tree", 1, 1,
		ResourceLoader.load("res://textures/tree1.png"),
		preload("res://scenes/Tree1.tscn")));
	tree_types.append(GDTreeType.new("fast tree", 2, 2,
		ResourceLoader.load("res://textures/tree2.png"),
		preload("res://scenes/Tree2.tscn")));
	tree_types.append(GDTreeType.new("nice tree", 2, 2,
		ResourceLoader.load("res://textures/tree2.png"),
		preload("res://scenes/Tree2.tscn")));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
