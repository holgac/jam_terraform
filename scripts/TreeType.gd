class_name GDTreeType

var name: String = "unnamed tree";
var trunk_growth_coef: float;
var branch_growth_coef: float;
var display_branch_on_growth: float;
var display_leaf_on_growth: float;
var display_fruit_on_growth: float;
var texture: Texture2D;
var mesh: PackedScene;
var tooltip: String;
var material_usage: Dictionary;
var gas_usage: Dictionary;
var gas_production: Dictionary;

static func _from_json(data: Variant) -> GDTreeType:
	var res: GDTreeType = GDTreeType.new();
	res.name = data['name'] if 'name' in data else 'UNNAMED TREE';
	res.trunk_growth_coef = data['trunk_growth_coef'] if 'trunk_growth_coef' in data else 1.0;
	res.branch_growth_coef = data['branch_growth_coef'] if 'branch_growth_coef' in data else 1.0;
	res.display_branch_on_growth = 1;
	res.display_leaf_on_growth = 1;
	res.display_fruit_on_growth = 1;

	if 'display' in data:
		var disp = data['display']
		if 'branch' in disp:
			res.display_branch_on_growth = disp['branch']
		if 'leaf' in disp:
			res.display_leaf_on_growth = disp['leaf']
		if 'fruit' in disp:
			res.display_fruit_on_growth = disp['fruit']
	if 'material_usage' in data:
		var usage = data['material_usage']
		for u in usage.keys():
			res.material_usage[u] = usage[u];
	if 'gas_usage' in data:
		var usage = data['gas_usage']
		for u in usage.keys():
			res.gas_usage[u] = usage[u];
	if 'gas_production' in data:
		var prod = data['gas_production']
		for p in prod.keys():
			res.gas_production[p] = prod[p];

	res.texture = ResourceLoader.load(data['texture'] if 'texture' in data else 'res://textures/tree1.png');
	res.mesh = ResourceLoader.load(data['mesh'] if 'mesh' in data else 'res://scenes/Tree1.tscn');
	res.tooltip = data['tooltip'] if 'tooltip' in data else 'NO INFO FOUND';
	return res

