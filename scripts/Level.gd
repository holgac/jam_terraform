extends Node3D
class_name GDLevel

var selected_tree_type: GDTreeType;
var selected_tree_entity: GDTree;
var HUD: GDHUD;
var camera: Camera3D;
var trees: Node3D;
var RAY_LENGTH: int = 200;
var GRID_COUNT_PER_EDGE: int = 100;
var is_cursor_on_ui: bool = false;
var grids: Array[GDGrid] = [];

@onready var global_settings: GDGlobalSettings = $GlobalSettings;

func _to_grid_array_coords(x: int, y: int):
	return y * GRID_COUNT_PER_EDGE + x;

func _base_ready():
	camera = get_node("Camera/Camera3D");
	trees = get_node("Trees");
	HUD = get_node("HUD");
	HUD.connect("tree_type_selected", _tree_type_selected);
	var gameView = HUD.get_node("Game")
	gameView.connect("mouse_entered", _hud_mouse_entered);
	gameView.connect("mouse_exited", _hud_mouse_exited);
	var secondTimer = get_node("SecondTimer");
	secondTimer.connect("timeout", _on_second_callback);
	for x in range(GRID_COUNT_PER_EDGE):
		for y in range(GRID_COUNT_PER_EDGE):
			# TODO: set with level defaults (one level has high nitrogen etc)
			grids.append(GDGrid.new());

func _on_second_callback():
	# process all existing trees
	for tree_node in trees.get_children():
		var tree: GDTree = tree_node;
		tree.grow(global_settings.time_coef);

func _hud_mouse_entered():
	print('mouse entered')
	if selected_tree_entity:
		selected_tree_entity.show()
		is_cursor_on_ui = false;

func _hud_mouse_exited():
	print('mouse exited')
	if selected_tree_entity:
		selected_tree_entity.hide()
		is_cursor_on_ui = true;

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
	var space_state = get_world_3d().direct_space_state;
	var mousepos = get_viewport().get_mouse_position();

	var origin = camera.project_ray_origin(mousepos);
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH;
	var query = PhysicsRayQueryParameters3D.create(origin, end);
	query.collide_with_areas = true;

	# TODO: set coll mask; this'll intersect with other trees once (if?) their physics are imported
	var result = space_state.intersect_ray(query);
	var is_hovering_valid: bool = false;
	if result:
		var collider = result['collider'];
		var parent = collider.get_parent();
		# TODO: can also do this via physics materials
		if parent.name == 'water':
			is_hovering_valid = false;
		else:
			selected_tree_entity.position = result.position;
			is_hovering_valid = true;
	if is_hovering_valid:
		selected_tree_entity.show();
	else:
		selected_tree_entity.hide();

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1 and
			selected_tree_entity and selected_tree_entity.is_visible()):
		var new_entity: GDTree = selected_tree_type.mesh.instantiate();
		new_entity.position = selected_tree_entity.position;
		new_entity.tree_type = selected_tree_type;
		trees.add_child(new_entity)
	elif (event is InputEventMouseButton and event.pressed and event.button_index == 2 and
			selected_tree_entity):
		selected_tree_entity.queue_free();
		selected_tree_entity = null;
		selected_tree_type = null;
