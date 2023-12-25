extends Node3D
class_name GDCamera

@export var movement_speed: float = 20.0;
@export var elevation_speed: float = 10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement: Vector3 = Vector3.ZERO;
	if Input.is_action_pressed("camera_up"):
		movement.y = elevation_speed;
	if Input.is_action_pressed("camera_down"):
		movement.y = -elevation_speed;
	if Input.is_action_pressed("camera_forward"):
		movement.z = -movement_speed;
	if Input.is_action_pressed("camera_back"):
		movement.z = movement_speed;
	if Input.is_action_pressed("camera_left"):
		movement.x = -movement_speed;
	if Input.is_action_pressed("camera_right"):
		movement.x = movement_speed;
	if movement.length_squared() > 0.1:
		translate(movement * delta);
