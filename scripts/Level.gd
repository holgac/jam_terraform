extends Node3D
class_name GDLevel

var selected_tree_type: GDTreeType;
var selected_tree_entity: GDTree;
var HUD: GDHUD;
var camera: Camera3D;
var RAY_LENGTH: int = 200;
var is_cursor_on_ui: bool = false;

func _base_ready():
	camera = get_node("Camera/Camera3D");
	HUD = get_node("HUD");
	HUD.connect("tree_type_selected", _tree_type_selected);
	var gameView = HUD.get_node("Game")
	gameView.connect("mouse_entered", _hud_mouse_entered);
	gameView.connect("mouse_exited", _hud_mouse_exited);

func _hud_mouse_entered():
	print('mouse entered')
	if selected_tree_entity:
		print(str('was visible: ', selected_tree_entity.is_visible()))
		selected_tree_entity.show()
		is_cursor_on_ui = false;
		print(str('is visible: ', selected_tree_entity.is_visible()))

func _hud_mouse_exited():
	print('mouse exited')
	if selected_tree_entity:
		print(str('was visible: ', selected_tree_entity.is_visible()))
		selected_tree_entity.hide()
		is_cursor_on_ui = true;
		print(str('is visible: ', selected_tree_entity.is_visible()))

func _base_physics_process():
	_update_selected_tree_entity();

func _tree_type_selected(tree_type: GDTreeType):
	var position: Vector3 = Vector3.ZERO;
	if selected_tree_entity:
		position = selected_tree_entity.position;
		selected_tree_entity.get_parent().remove_child(selected_tree_entity);
		selected_tree_entity.queue_free();
	selected_tree_type = tree_type;
	selected_tree_entity = selected_tree_type.mesh.instantiate();
	# TODO: semi transparent (set albedo.alpha of SpatialMaterial of MeshInstance(s))
	selected_tree_entity.position = position;
	add_child(selected_tree_entity);

func _update_selected_tree_entity():
	if not selected_tree_entity or is_cursor_on_ui:
		return
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	# TODO: set coll mask; this'll intersect with other trees once (if?) their physics are imported
	var result = space_state.intersect_ray(query)
	if result:
		selected_tree_entity.position = result.position;
		selected_tree_entity.show();
	else:
		selected_tree_entity.hide();

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1 and
			selected_tree_entity and selected_tree_entity.is_visible()):
		var new_entity = selected_tree_type.mesh.instantiate();
		new_entity.position = selected_tree_entity.position;
		add_child(new_entity)
