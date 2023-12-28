class_name GDGridMap;

const NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE = 2;

var grids: Array[GDGrid] = [];
var pos_to_grid_mult: float;

func _init(level_settings: GDLevelSettings, terrain: Node3D):
  var min_coords: Vector3 = Vector3.ZERO;
  var max_coords: Vector3 = Vector3.ZERO;
  for child in terrain.get_children():
    if child.get_name() == 'blocked_area':
      continue;
    assert(child is MeshInstance3D, "Invalid terrain!");
    var aabb: AABB = child.get_aabb();
    min_coords = Vector3(
      min(min_coords.x, aabb.position.x),
      min(min_coords.y, aabb.position.y),
      min(min_coords.z, aabb.position.z),
    );
    max_coords = Vector3(
      max(max_coords.x, aabb.position.x + aabb.size.x),
      max(max_coords.y, aabb.position.y + aabb.size.y),
      max(max_coords.z, aabb.position.z + aabb.size.z),
    );
  var grid_size: float = (max_coords.x - min_coords.x) / GDConsts.GRID_COUNT_PER_EDGE;
  pos_to_grid_mult = 1.0 / grid_size;
  var ray_increment = grid_size / NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE;
  for x in range(GDConsts.GRID_COUNT_PER_EDGE):
    for y in range(GDConsts.GRID_COUNT_PER_EDGE):
      var dominant_terrain_type: String;
      var max_terrain_counter: int = 0;
      var terrain_counters: Dictionary = {};
      for i in range(NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE):
        for j in range(NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE):
          var pos: Vector3 = Vector3(
          ray_increment * 0.5 + grid_size * x + ray_increment * i,
          max_coords.y + 1,
          -ray_increment * 0.5 - grid_size * y - ray_increment * j);
          var result = GDUtils.cast_ray(
            pos,
            Vector3(pos.x, min_coords.y - 1.0, pos.z),
            GDConsts.PHYSICS_LAYERS.Terrain,
            terrain.get_world_3d().direct_space_state);
          assert(result, "Invalid terrain!")
          var ter: Node = result['collider'].get_parent();
          terrain_counters[ter.get_name()] = terrain_counters.get(ter.get_name(), 0) + 1;
          if terrain_counters[ter.get_name()] > max_terrain_counter:
            max_terrain_counter = terrain_counters[ter.get_name()]
            dominant_terrain_type = ter.get_name();
      grids.append(GDGrid.new(level_settings, dominant_terrain_type));


func get_grid(pos: Vector2i):
  return grids[_to_grid_array_coords(pos)]


func replenish(level_settings: GDLevelSettings, delta: float):
  for i in range(GDConsts.GRID_COUNT_PER_EDGE * GDConsts.GRID_COUNT_PER_EDGE):
    var grid: GDGrid = grids[i];
    grid.replenish(level_settings, GlobalSettings.time_coef * delta);


func world_pos_to_grid(pos: Vector3):
  var grid_x: int = int(pos.x * pos_to_grid_mult);
  # -z because our map goes from 0 to -TERRAIN_EDGE_LENGTH in z coords
  var grid_y: int = int(-pos.z * pos_to_grid_mult);
  return Vector2i(grid_x, grid_y);

func _to_grid_array_coords(pos: Vector2i):
  return pos.y * GDConsts.GRID_COUNT_PER_EDGE + pos.x;
