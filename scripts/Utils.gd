class_name GDUtils

static func cast_ray_from_camera(camera: Camera3D, mask: int):
  var mousepos = camera.get_viewport().get_mouse_position();
  var origin = camera.project_ray_origin(mousepos);
  var end = origin + camera.project_ray_normal(mousepos) * GDConsts.RAY_LENGTH;
  return cast_ray(origin, end, mask, camera.get_world_3d().direct_space_state)

static func cast_ray(origin: Vector3, end: Vector3, mask: int, space_state: PhysicsDirectSpaceState3D):
  var query = PhysicsRayQueryParameters3D.create(origin, end);
  # TODO: this isn't necessary? test and rm
  query.collide_with_areas = true;
  query.collision_mask = mask;
  return space_state.intersect_ray(query);
