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
var phosphorus_usage: float;
var potassium_usage: float;
var calcium_usage: float;

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
	res.phosphorus_usage = 0.0;
	res.potassium_usage = 0.0;
	res.calcium_usage = 0.0;
	if 'usage' in data:
		var usage = data['usage']
		if 'phosphorus' in usage:
			res.phosphorus_usage = usage['phosphorus']
		if 'potassium' in usage:
			res.potassium_usage = usage['potassium']
		if 'calcium' in usage:
			res.calcium_usage = usage['calcium']

	res.texture = ResourceLoader.load(data['texture'] if 'texture' in data else 'res://textures/tree1.png');
	res.mesh = ResourceLoader.load(data['mesh'] if 'mesh' in data else 'res://scenes/Tree1.tscn');
	res.tooltip = data['tooltip'] if 'tooltip' in data else 'NO INFO FOUND';
	return res

