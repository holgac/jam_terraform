extends VBoxContainer
class_name GDTreeSelector;

var tree_type: GDTreeType;
signal pressed(tree_type: GDTreeType);

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture: TextureButton = get_node("Texture");
	texture.set_texture_normal(tree_type.texture);
	var tooltip: String = tree_type.tooltip;
	for mat in tree_type.material_usage.keys():
		var val = tree_type.material_usage[mat];
		if val > 0:
			tooltip += str('\nNeeds ', val, " ", mat, " per sec");
	for gas in tree_type.gas_usage.keys():
		var val = tree_type.gas_usage[gas];
		if val > 0:
			tooltip += str('\nNeeds ', val, " ", gas, " per sec");
	for mat in tree_type.material_production.keys():
		var val = tree_type.material_production[mat];
		if val > 0:
			tooltip += str('\nProduces ', val, " ", mat, " per sec");
	for gas in tree_type.gas_production.keys():
		var val = tree_type.gas_production[gas];
		if val > 0:
			tooltip += str('\nProduces ', val, " ", gas, " per sec");
	texture.set_tooltip_text(tooltip);
	var label = get_node("Name");
	label.set_text(tree_type.name);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_texture_pressed():
	pressed.emit(tree_type);
