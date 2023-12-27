class_name GDLevelSettings;

# default grid settings
# these will be further modified by water/volcano proximity, elevation etc
var default_grid_contents: Dictionary;

var default_air_contents: Dictionary;
# converges the given gases to the assigned values (i.e. replenish selectively)
# var air_contents_converge: Dictionary;

# replenish rate of N will replenish (def - cur) * N per second
var mineral_replenish_rate: float = 0.05;
var air_replenish_rate: float = 5.0;

func _init(_default_grid_content: float = 10.0):
	for i in range(GDConsts.MATERIAL.COUNT):
		default_grid_contents[GDConsts.MATERIAL_NAME[i]] = _default_grid_content;
	for i in range(GDConsts.GAS.COUNT):
		default_air_contents[GDConsts.GAS_NAME[i]] = 1.0 / GDConsts.GAS.COUNT;
	default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Nitrogen]] = 0.8;
	default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Carbondioxide]] = 0.2;
