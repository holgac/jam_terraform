extends Node3D
class_name GDTree

var tree_type: GDTreeType;
var growth: float = 0.0;
var parts: Dictionary = {};
const MIN_MINERAL_USAGE: float = 0.1;
const MAX_GROWTH: float = 10.0;

func _consume_and_get_ratio(cell: GDCell, air: GDAir, time_coef: float):
  var ratio = 1.0;
  for part in GDConsts.PLANT_PART_NAME:
    if not parts[part].is_visible():
      continue
    for mat in tree_type.material_usage.get(part, {}).keys():
      if cell.contents[mat] < tree_type.material_usage[part][mat] * time_coef:
        ratio = min(ratio, cell.contents[mat] / tree_type.material_usage[part][mat] * time_coef);
    for gas in tree_type.gas_usage.get(part, {}).keys():
      if air.contents[gas] < tree_type.gas_usage[part][gas] * time_coef:
        ratio = min(ratio, air.contents[gas] / tree_type.gas_usage[part][gas] * time_coef);
  ratio = max(ratio, 0.0);
  for part in GDConsts.PLANT_PART_NAME:
    if not parts[part].is_visible():
      continue
    for mat in tree_type.material_usage.get(part, {}).keys():
      cell.contents[mat] -= ratio * tree_type.material_usage[part][mat] * time_coef
    for mat in tree_type.material_production.get(part, {}).keys():
      cell.contents[mat] += ratio * tree_type.material_production[part][mat]
    for gas in tree_type.gas_usage.get(part, {}).keys():
      air.contents[gas] -= ratio * tree_type.gas_usage[part][gas] * time_coef
    for gas in tree_type.gas_production.get(part, {}).keys():
      air.contents[gas] += ratio * tree_type.gas_production[part][gas]
  return ratio

func grow(cell: GDCell, air: GDAir, time_coef: float, growth_coef: float):
  var ratio = _consume_and_get_ratio(cell, air, time_coef);
  if ratio < 0.1:
      growth = max(growth - time_coef * growth_coef, time_coef * growth_coef);
  elif ratio < 0.99:
    pass
  else:
    growth = min(growth + time_coef * growth_coef, MAX_GROWTH);

  scale = growth * Vector3(tree_type.branch_growth_coef, tree_type.trunk_growth_coef, tree_type.branch_growth_coef);
  for part in GDConsts.PLANT_PART_NAME:
    if growth >= tree_type.display_on_growth.get(part, 0.0):
      parts[part].show();
    else:
      parts[part].hide();

# Called when the node enters the scene tree for the first time.
func _ready():
  for part in GDConsts.PLANT_PART_NAME:
    parts[part] = get_node('tree/' + part);

