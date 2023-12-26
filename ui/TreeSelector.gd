extends VBoxContainer
class_name GDTreeSelector;

var tree_type: GDTreeType;
signal pressed(tree_type: GDTreeType);

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture: TextureButton = get_node("Texture");
	texture.set_texture_normal(tree_type.texture);
	var tooltip: String = tree_type.tooltip;
	if tree_type.phosphorus_usage > 0:
		tooltip += str('\nNeeds ', tree_type.phosphorus_usage, " phosphorus per sec");
	if tree_type.potassium_usage > 0:
		tooltip += str('\nNeeds ', tree_type.potassium_usage, " potassium per sec");
	if tree_type.calcium_usage > 0:
		tooltip += str('\nNeeds ', tree_type.calcium_usage, " calcium per sec");
	texture.set_tooltip_text(tooltip);
	var label = get_node("Name");
	label.set_text(tree_type.name);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_pressed():
	pressed.emit(tree_type);
