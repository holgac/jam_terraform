class_name GDGrid;

const NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE = 2;

var cells: Array[GDCell] = [];
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
  var cell_size: float = int((max_coords.x - min_coords.x) / GDConsts.CELL_COUNT_PER_EDGE);
  pos_to_grid_mult = 1.0 / cell_size;
  var ray_increment = cell_size / NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE;
  var st: SurfaceTool = SurfaceTool.new();
  st.begin(Mesh.PRIMITIVE_LINES)
  st.set_uv(Vector2(0, 0));
  st.set_normal(Vector3(0, 1, 0));

  for y in range(GDConsts.CELL_COUNT_PER_EDGE):
    for x in range(GDConsts.CELL_COUNT_PER_EDGE):
      _create_grid_lines(cell_size, terrain, x, y, min_coords.y - 1, max_coords.y + 1, st);
      var dominant_terrain_type = _get_dominant_terrain_type(
        cell_size, terrain, x, y, min_coords.y - 1, max_coords.y + 1);
      cells.append(GDCell.new(level_settings, dominant_terrain_type));
  var mesh = st.commit();
  var m = MeshInstance3D.new();
  m.mesh = mesh;
  terrain.add_child(m);


func get_cell(pos: Vector2i):
  return cells[_to_grid_array_coords(pos)]


func replenish(level_settings: GDLevelSettings, delta: float):
  for y in range(GDConsts.CELL_COUNT_PER_EDGE):
    for x in range(GDConsts.CELL_COUNT_PER_EDGE):
      var cell: GDCell = get_cell(Vector2(x, y));
      var neighbours: Array[Vector2i] = []
      if x > 0:
        neighbours.append(Vector2i(x-1, y));
      if y > 0:
        neighbours.append(Vector2i(x, y-1));
      if x < GDConsts.CELL_COUNT_PER_EDGE - 1:
        neighbours.append(Vector2i(x+1, y));
      if y < GDConsts.CELL_COUNT_PER_EDGE - 1:
        neighbours.append(Vector2i(x, y+1));
      for mat in GDConsts.MATERIAL_NAME:
        var can_get_max = 0.25 * GlobalSettings.CELL_MATERIAL_DRAW_COEF * delta * (cell.default_contents[mat] - cell.contents[mat]);
        for neighbour in neighbours:
          var ncell = get_cell(neighbour);
          var sup_power = ncell.contents[mat] / ncell.default_contents[mat];
          var draw_amount = can_get_max * sup_power;
          draw_amount = min(draw_amount, ncell.contents[mat]);
          draw_amount = min(draw_amount, cell.default_contents[mat] - cell.contents[mat]);
          if draw_amount > 0:
            ncell.contents[mat] -= draw_amount;
            cell.contents[mat] += draw_amount;

  for y in range(GDConsts.CELL_COUNT_PER_EDGE):
    for x in range(GDConsts.CELL_COUNT_PER_EDGE):
      var cell: GDCell = get_cell(Vector2(x, y));
      cell.replenish(level_settings, GlobalSettings.time_coef * delta);


func world_pos_to_grid(pos: Vector3):
  var grid_x: int = int(pos.x * pos_to_grid_mult);
  # -z because our map goes from 0 to -TERRAIN_EDGE_LENGTH in z coords
  var grid_y: int = int(-pos.z * pos_to_grid_mult);
  return Vector2i(grid_x, grid_y);

func _to_grid_array_coords(pos: Vector2i):
  return pos.y * GDConsts.CELL_COUNT_PER_EDGE + pos.x;

func _get_dominant_terrain_type(cell_size: float, terrain: Node3D, x: int, y: int, min_height: float, max_height: float):
  var ray_increment = cell_size / NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE;
  var terrain_counters: Dictionary = {};
  var dominant_terrain_type: String;
  var max_terrain_counter: int = 0;

  for i in range(NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE):
    for j in range(NUM_RAYS_TO_DETERMINE_TERRAIN_TYPE):
      var pos: Vector3 = Vector3(
      ray_increment * 0.5 + cell_size * x + ray_increment * i,
      max_height,
      -ray_increment * 0.5 - cell_size * y - ray_increment * j);
      var result = GDUtils.cast_ray(
        pos,
        Vector3(pos.x, min_height, pos.z),
        GDConsts.PHYSICS_LAYERS.Terrain,
        terrain.get_world_3d().direct_space_state);
      assert(result, "Invalid terrain!")
      var ter: Node = result['collider'].get_parent();
      terrain_counters[ter.get_name()] = terrain_counters.get(ter.get_name(), 0) + 1;
      if terrain_counters[ter.get_name()] > max_terrain_counter:
        max_terrain_counter = terrain_counters[ter.get_name()]
        dominant_terrain_type = ter.get_name();
  return dominant_terrain_type;

func _create_grid_lines(cell_size: float, terrain: Node3D, x: int, y: int, min_height: float, max_height: float, st: SurfaceTool):
  var line_increment = cell_size / GDConsts.GRID_LINE_COUNT_PER_CELL_EDGE;
  var init_pos: Vector3 = Vector3(x * cell_size + 0.01, max_height, -y * cell_size - 0.01);
  var result = GDUtils.cast_ray(init_pos, Vector3(init_pos.x + 0.001, min_height, init_pos.z - 0.001),
        GDConsts.PHYSICS_LAYERS.Terrain, terrain.get_world_3d().direct_space_state);
  init_pos.y = result.position.y;
  var prev_pos: Vector3 = init_pos;
  for i in range(GDConsts.GRID_LINE_COUNT_PER_CELL_EDGE):
    var pos: Vector3 = Vector3(x * cell_size, max_height, -y * cell_size - (i + 1) * line_increment + 0.001);
    result = GDUtils.cast_ray(pos, Vector3(pos.x, min_height, pos.z),
          GDConsts.PHYSICS_LAYERS.Terrain, terrain.get_world_3d().direct_space_state);
    pos.y = result.position.y
    st.add_vertex(Vector3(prev_pos.x, prev_pos.y + 0.2, prev_pos.z));
    st.add_vertex(Vector3(pos.x, pos.y + 0.2, pos.z));
    prev_pos = pos;
  prev_pos = init_pos;
  for i in range(GDConsts.GRID_LINE_COUNT_PER_CELL_EDGE):
    var pos: Vector3 = Vector3(x * cell_size + (i + 1) * line_increment - 0.01, max_height, -y * cell_size);
    result = GDUtils.cast_ray(pos, Vector3(pos.x, min_height, pos.z),
          GDConsts.PHYSICS_LAYERS.Terrain, terrain.get_world_3d().direct_space_state);
    pos.y = result.position.y;
    st.add_vertex(Vector3(prev_pos.x, prev_pos.y + 0.2, prev_pos.z));
    st.add_vertex(Vector3(pos.x, pos.y + 0.2, pos.z));
    prev_pos = pos;
