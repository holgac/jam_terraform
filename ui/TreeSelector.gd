extends VBoxContainer
class_name GDTreeSelector;

var tree_type: GDTreeType;
signal pressed(tree_type: GDTreeType);

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture: TextureButton = get_node("Texture");
	texture.set_texture_normal(tree_type.texture);
	texture.set_tooltip_text(tree_type.tooltip);
	var label = get_node("Name");
	label.set_text(tree_type.name);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_pressed():
	pressed.emit(tree_type);
