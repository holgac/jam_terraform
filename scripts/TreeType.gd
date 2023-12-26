class_name GDTreeType

# export doesn't work here
@export var name: String = "unnamed tree";
@export var trunk_growth_coef: float = 1;
@export var branch_growth_coef: float = 1;
@export var display_branch_on_growth: float = 1;
@export var display_leaf_on_growth: float = 1;
@export var display_fruit_on_growth: float = 1;
@export var texture: Texture2D;
@export var mesh: PackedScene;
@export var tooltip: String;

static func _from_json(data: Variant) -> GDTreeType:
	var _name: String = data['name'] if 'name' in data else 'UNNAMED TREE';
	var _trunk_growth_coef: float = data['trunk_growth_coef'] if 'trunk_growth_coef' in data else 1.0;
	var _branch_growth_coef: float = data['branch_growth_coef'] if 'branch_growth_coef' in data else 1.0;
	var _display_branch_on_growth: float = 1;
	var _display_leaf_on_growth: float = 1;
	var _display_fruit_on_growth: float = 1;

	if 'display' in data:
		var disp = data['display']
		if 'branch' in disp:
			_display_branch_on_growth = disp['branch']
		if 'leaf' in disp:
			_display_leaf_on_growth = disp['leaf']
		if 'fruit' in disp:
			_display_fruit_on_growth = disp['fruit']

	var _texture: String = data['texture'] if 'texture' in data else 'res://textures/tree1.png';
	var _mesh: String = data['mesh'] if 'mesh' in data else 'res://scenes/Tree1.tscn';
	var _tooltip: String = data['tooltip'] if 'tooltip' in data else 'NO INFO FOUND';
	return GDTreeType.new(
		_name,
		_trunk_growth_coef,
		_branch_growth_coef,
		_display_branch_on_growth,
		_display_leaf_on_growth,
		_display_fruit_on_growth,
		ResourceLoader.load(_texture),
		ResourceLoader.load(_mesh),
		_tooltip,
	);

func _init(_name: String, _trunk_growth_coef: float, _branch_growth_coef: float,
		_display_branch_on_growth: float, _display_leaf_on_growth: float, _display_fruit_on_growth: float,
		_texture: Texture2D, _mesh: PackedScene, _tooltip: String):
	name = _name;
	trunk_growth_coef = _trunk_growth_coef;
	branch_growth_coef = _branch_growth_coef;
	display_branch_on_growth = _display_branch_on_growth;
	display_leaf_on_growth = _display_leaf_on_growth;
	display_fruit_on_growth = _display_fruit_on_growth;
	texture = _texture;
	mesh = _mesh;
	tooltip = _tooltip;
