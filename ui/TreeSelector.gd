extends VBoxContainer
class_name GDTreeSelector;

var tree_type: GDTreeType;
signal pressed(tree_type: GDTreeType);

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture: TextureButton = get_node("Texture");
	texture.set_texture_normal(tree_type.texture);
	var tooltip: String = tree_type.tooltip;
	for mat in GDConsts.MATERIAL_NAME:
		var val = tree_type.material_usage.get(mat, 0);
		if val > 0:
			tooltip += str('\nNeeds ', val, " ", mat, " per sec");
	texture.set_tooltip_text(tooltip);
	var label = get_node("Name");
	label.set_text(tree_type.name);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_pressed():
	pressed.emit(tree_type);
