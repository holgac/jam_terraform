class_name GDCell

# minerals
# set at once per level
# converges back to original values slowly
# plants change them
# [GDConsts.MATERIAL, float]
var contents: Dictionary;
var default_contents: Dictionary;
var type: String;

func _init(level_settings: GDLevelSettings, _type: String):
  type = _type;
  for mat in GDConsts.MATERIAL_NAME:
    default_contents[mat] = level_settings.default_grid_contents[mat] * GlobalSettings.terrain_types[type][mat];
  contents = default_contents.duplicate();

func replenish(level_settings: GDLevelSettings, time_coef: float):
  for mat in GDConsts.MATERIAL_NAME:
    if contents[mat] > default_contents[mat]:
      contents[mat] += 4 * (default_contents[mat] - contents[mat]) * time_coef * level_settings.mineral_replenish_rate;
    else:
      contents[mat] += (default_contents[mat] - contents[mat]) * time_coef * level_settings.mineral_replenish_rate;
