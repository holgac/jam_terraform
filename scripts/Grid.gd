class_name GDGrid

# minerals
# set at once per level
# converges back to original values slowly
# plants change them
# [GDConsts.MATERIAL, float]
# TODO: rename to material_contents
var contents: Dictionary;
var default_contents: Dictionary;

func _init(level_settings: GDLevelSettings, type: String):
  contents = level_settings.default_grid_contents.duplicate();
  default_contents = level_settings.default_grid_contents.duplicate();
  print('dominant type:', type)
  # do per-type stuff here, reading types from GlobalSettings

func replenish(level_settings: GDLevelSettings, time_coef: float):
  for mat in GDConsts.MATERIAL_NAME:
    contents[mat] += (default_contents[mat] - contents[mat]) * time_coef * level_settings.mineral_replenish_rate;
