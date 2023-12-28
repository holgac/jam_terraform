class_name GDUtils

static func to_grid_array_coords(pos: Vector2i):
  return pos.y * GDConsts.GRID_COUNT_PER_EDGE + pos.x;

static func world_pos_to_grid(pos: Vector3, pos_to_grid_mult: float):
  var grid_x: int = int(pos.x * pos_to_grid_mult);
  # -z because our map goes from 0 to -TERRAIN_EDGE_LENGTH in z coords
  var grid_y: int = int(-pos.z * pos_to_grid_mult);
  return Vector2i(grid_x, grid_y);


