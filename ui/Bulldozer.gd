extends VBoxContainer;
class_name GDBulldozer;

signal pressed;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('Texture').connect('pressed', _button_pressed);

func _button_pressed():
	pressed.emit();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
