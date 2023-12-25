class_name GDTreeType

# export doesn't work here
@export var name: String = "unnamed tree";
@export var trunk_growth_coef: float = 1;
@export var branch_growth_coef: float = 1;
@export var texture: Texture2D;
@export var mesh: PackedScene;

func _init(_name: String, _trunk_growth_coef: float, _branch_growth_coef: float, _texture: Texture2D, _mesh: PackedScene):
	name = _name;
	trunk_growth_coef = _trunk_growth_coef;
	branch_growth_coef = _branch_growth_coef;
	texture = _texture;
	mesh = _mesh;
