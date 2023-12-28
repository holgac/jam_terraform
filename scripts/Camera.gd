extends Node3D
class_name GDCamera

@export var movement_speed: float = 20.0;
@export var elevation_speed: float = 10.0;
@export var rotate_speed: float = 0.5;
@export var out_of_bounds_allowance = 20.0;
var terrain_size = 0.0;
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
  if Input.is_action_pressed("camera_rotate_cw"):
    rotate_y(rotate_speed * delta);
  if Input.is_action_pressed("camera_rotate_ccw"):
    rotate_y(-rotate_speed * delta);
  if movement.length_squared() > 0.1:
    var speed_coef: float = 1.0;
    if Input.is_action_pressed("camera_boost"):
      speed_coef = 5.0;
    translate(movement * (delta * speed_coef));
    if position.x < -out_of_bounds_allowance:
      position.x = -out_of_bounds_allowance;
    if position.x > terrain_size + out_of_bounds_allowance:
      position.x = terrain_size + out_of_bounds_allowance;
    if position.z > out_of_bounds_allowance:
      position.z = out_of_bounds_allowance;
    if position.z < -terrain_size - out_of_bounds_allowance:
      position.z = -terrain_size - out_of_bounds_allowance;
