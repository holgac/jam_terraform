extends GDLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	level_settings = GDLevelSettings.new();
	for i in range(GDConsts.GAS.COUNT):
		level_settings.default_air_contents[GDConsts.GAS_NAME[i]] = 0.0;
	level_settings.default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Nitrogen]] = 8000;
	level_settings.default_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Carbondioxide]] = 2000;
	level_settings.air_contents_increment[GDConsts.GAS_NAME[GDConsts.GAS.Nitrogen]] = 20;
	level_settings.air_contents_increment[GDConsts.GAS_NAME[GDConsts.GAS.Carbondioxide]] = 5;
	winning_conditions = GDWinningConditions.new();
	winning_conditions.min_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Oxygen]] = 0.1;
	winning_conditions.min_plant_count['hungry tree'] = 10;
	_base_ready();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	_base_physics_process();
