extends Node3D
class_name GDTree

var tree_type: GDTreeType;
var growth: float = 0.0;
const BRANCH: String = 'Scene/tree/branch';
const LEAF: String = 'Scene/tree/leaf';
const FRUIT: String = 'Scene/tree/fruit';
const BODY: String = 'Scene/tree/body';


func grow(amount: float):
	if growth > 20:
		return
	var old_growth = growth;
	growth += amount;
	scale = Vector3.ONE * growth;
	# TODO: don't hard-code these, make it part of tree type to make meshes reusable
	if old_growth < 1.0 and growth >= 1.0:
		get_node(BRANCH).show();
	elif old_growth < 3.0 and growth >= 3.0:
		get_node(LEAF).show();
	elif old_growth < 10.0 and growth >= 10.0:
		get_node(FRUIT).show();

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(BRANCH).hide();
	get_node(FRUIT).hide();
	get_node(LEAF).hide();
	get_node(BODY).show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
