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
  winning_conditions.min_air_contents[GDConsts.GAS_NAME[GDConsts.GAS.Oxygen]] = 0.05;
  winning_conditions.min_plant_count['cactus'] = 10;
  _base_ready();

  var alert: AcceptDialog = get_node("Alert");
  alert.set_title("Level 3: Desert Something");
  alert.set_text("In this mission, get at least 5% oxygen and plant 10 cacti.\n");
  alert.show();
  # alert.connect('canceled', alert.queue_free.bind());
  # alert.connect('confirmed', alert.queue_free.bind());


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass

func _physics_process(_delta):
  _base_physics_process();

func _on_level_won():
  var alert: AcceptDialog = get_node("Alert");
  alert.set_text("You have finished the game!");
  alert.connect('canceled', Session.goto_scene.bind(Session.MainMenuScene));
  alert.connect('confirmed', Session.goto_scene.bind(Session.CreditsScene));
  alert.show();