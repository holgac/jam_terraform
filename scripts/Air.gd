class_name GDAir

var contents: Dictionary;

func _init(level_settings: GDLevelSettings):
	contents = level_settings.default_air_contents;
