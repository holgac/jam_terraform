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

func _consume_and_get_ratio(grid: GDGrid, air: GDAir, time_coef: float):
	var ratio = 1.0;
	for mat in tree_type.material_usage.keys():
		if grid.contents[mat] < tree_type.material_usage[mat] * time_coef:
			ratio = min(ratio, grid.contents[mat] / tree_type.material_usage[mat] * time_coef);
	for mat in tree_type.material_usage.keys():
		grid.contents[mat] -= ratio * tree_type.material_usage[mat] * time_coef
	for gas in tree_type.gas_production.keys():
		air.contents[gas] += ratio * tree_type.gas_production[gas]
	return ratio

func grow(grid: GDGrid, air: GDAir, time_coef: float):
	var ratio = self._consume_and_get_ratio(grid, air, time_coef);
	if ratio < 0.1:
			growth = max(growth - time_coef, time_coef);
	elif ratio < 0.99:
		pass
	else:
		growth = min(growth + time_coef, MAX_GROWTH);

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
