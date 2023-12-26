class_name GDGrid

# minerals
# set at once per level
# converges back to original values slowly
# plants change them
# [GDConsts.MATERIAL, float]
# TODO: rename to material_contents
var contents: Dictionary;
var default_contents: Dictionary;

func _init(level_settings: GDLevelSettings):
	default_contents = level_settings.default_grid_contents;
	_reset_to_default_values();

func replenish(level_settings: GDLevelSettings, time_coef: float):
	for mat in GDConsts.MATERIAL_NAME:
		contents[mat] += (default_contents[mat] - contents[mat]) * time_coef * level_settings.mineral_replenish_rate;

func _reset_to_default_values():
	for mat in GDConsts.MATERIAL_NAME:
		contents[mat] = default_contents[mat];
