extends GDLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	level_settings = GDLevelSettings.new();
	for i in range(GDConsts.GAS.COUNT):
		level_settings.default_air_contents[GDConsts.GAS_NAME[i]] = 0.0;
	level_settings.default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Nitrogen]] = 0.8;
	level_settings.default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Carbondioxide]] = 0.2;
	_base_ready();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	_base_physics_process();
