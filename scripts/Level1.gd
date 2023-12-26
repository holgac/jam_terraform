extends GDLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	level_settings = GDLevelSettings.new();
	_base_ready();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	_base_physics_process();
