class_name GDAir

var contents: Dictionary;
var default_contents: Dictionary;

func _init(level_settings: GDLevelSettings):
	contents = level_settings.default_air_contents.duplicate();
	default_contents = level_settings.default_air_contents.duplicate();

func replenish(level_settings: GDLevelSettings, time_coef: float):
	for gas in GDConsts.GAS_NAME:
		if level_settings.default_air_contents[gas] > contents[gas]:
			contents[gas] += (level_settings.default_air_contents[gas] - contents[gas]) * level_settings.air_replenish_rate * time_coef;

func normalize():
	var sum: float = 0;
	for gas in contents.keys():
		sum += contents[gas];
	var ratio: float = 1.0 / sum;
	for gas in contents.keys():
		contents[gas] *= ratio;
	
