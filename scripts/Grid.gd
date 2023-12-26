class_name GDGrid

# these are global per level
# var oxygen: float = 0.0;
# var nitrogen: float = 90.0;
# var carbondioxide: float = 10.0

# minerals
# set at once per level
# converges back to original values slowly
# plants change them
var phosphorus: float;
var potassium: float;
var calcium: float;

var default_phosphorus: float;
var default_potassium: float;
var default_calcium: float;

func _init(level_settings: GDLevelSettings):
	default_phosphorus = level_settings.phosphorus;
	default_potassium = level_settings.potassium;
	default_calcium = level_settings.calcium;
	_reset_to_default_values();

func replenish(level_settings: GDLevelSettings, time_coef: float):
	phosphorus += (default_phosphorus - phosphorus) * time_coef * level_settings.mineral_replenish_rate;
	potassium += (default_potassium - potassium) * time_coef * level_settings.mineral_replenish_rate;
	calcium += (default_calcium - calcium) * time_coef * level_settings.mineral_replenish_rate;

func _reset_to_default_values():
	phosphorus = default_phosphorus;
	potassium = default_potassium;
	calcium = default_calcium;
