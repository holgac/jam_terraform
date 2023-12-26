extends Node3D
class_name GDTree

var tree_type: GDTreeType;
var growth: float = 0.0;
@onready var branch: Node3D = get_node('tree/branch');
@onready var leaf: Node3D = get_node('tree/leaf');
@onready var body: Node3D = get_node('tree/body');
@onready var fruit: Node3D = get_node('tree/fruit');
const MIN_MINERAL_USAGE: float = 0.1;
const MAX_GROWTH: float = 10.0;


func grow(grid: GDGrid, time_coef: float):
	if (grid.phosphorus < tree_type.phosphorus_usage * time_coef
			or grid.potassium < tree_type.potassium_usage * time_coef
			or grid.calcium < tree_type.calcium_usage * time_coef):
		if (grid.phosphorus < tree_type.phosphorus_usage * time_coef * MIN_MINERAL_USAGE
				or grid.potassium < tree_type.potassium_usage * time_coef * MIN_MINERAL_USAGE
				or grid.calcium < tree_type.calcium_usage * time_coef * MIN_MINERAL_USAGE):
			# shrink if has less than minimum
			growth = max(growth - time_coef, time_coef);
	else:
		growth = min(growth + time_coef, MAX_GROWTH);

	grid.phosphorus = max(grid.phosphorus - tree_type.phosphorus_usage * time_coef, 0.0);
	grid.potassium = max(grid.potassium - tree_type.potassium_usage * time_coef, 0.0);
	grid.calcium = max(grid.calcium - tree_type.calcium_usage * time_coef, 0.0);
	scale = growth * Vector3(tree_type.branch_growth_coef, tree_type.trunk_growth_coef, tree_type.branch_growth_coef);
	if growth >= tree_type.display_branch_on_growth:
		branch.show();
	else:
		branch.hide();
	if growth >= tree_type.display_leaf_on_growth:
		leaf.show();
	else:
		leaf.hide();
	if growth >= tree_type.display_fruit_on_growth:
		fruit.show();
	else:
		fruit.hide();

# Called when the node enters the scene tree for the first time.
func _ready():
	branch.hide();
	fruit.hide();
	leaf.hide();
	body.show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
