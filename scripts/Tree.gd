extends Node3D
class_name GDTree

var tree_type: GDTreeType;
var growth: float = 0.0;
const BRANCH: String = 'tree/branch';
const LEAF: String = 'tree/leaf';
const FRUIT: String = 'tree/fruit';
const BODY: String = 'tree/body';


func grow(amount: float):
	if growth > 20:
		return
	var old_growth = growth;
	growth += amount;
	scale = growth * Vector3(tree_type.branch_growth_coef, tree_type.trunk_growth_coef, tree_type.branch_growth_coef);
	# TODO: don't hard-code these, make it part of tree type to make meshes reusable
	if old_growth < tree_type.display_branch_on_growth and growth >= tree_type.display_branch_on_growth:
		get_node(BRANCH).show();
	elif old_growth < tree_type.display_leaf_on_growth and growth >= tree_type.display_leaf_on_growth:
		get_node(LEAF).show();
	elif old_growth < tree_type.display_fruit_on_growth and growth >= tree_type.display_fruit_on_growth:
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
