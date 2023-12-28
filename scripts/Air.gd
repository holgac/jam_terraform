class_name GDAir

var contents: Dictionary;
var default_contents: Dictionary;

func _init(level_settings: GDLevelSettings):
  contents = level_settings.default_air_contents.duplicate();
  default_contents = level_settings.default_air_contents.duplicate();

func replenish(level_settings: GDLevelSettings, time_coef: float):
  for gas in level_settings.air_contents_increment.keys():
    contents[gas] += level_settings.air_contents_increment[gas] * level_settings.air_replenish_rate * time_coef;

func get_normalized():
  var val: Dictionary = {};
  var sum: float = 0;
  for gas in contents.keys():
    sum += contents[gas];
  var ratio: float = 1.0 / sum;
  for gas in contents.keys():
    val[gas] = ratio * contents[gas];
  return val;
  
