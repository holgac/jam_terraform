extends VBoxContainer
class_name GDTreeSelector;

var tree_type: GDTreeType;
signal pressed(tree_type: GDTreeType);

# Called when the node enters the scene tree for the first time.
func _ready():
  var texture: TextureButton = get_node("Texture");
  texture.set_texture_normal(tree_type.texture);
  var tooltip: String = tree_type.tooltip;
  var material_usage: Dictionary = {};
  var material_production: Dictionary = {};
  var gas_usage: Dictionary = {};
  var gas_production: Dictionary = {};
  for part in GDConsts.PLANT_PART_NAME:
    for mat in tree_type.material_usage.get(part, {}).keys():
      material_usage[mat] = tree_type.material_usage[part][mat] + material_usage.get(mat, 0.0);
    for gas in tree_type.gas_usage.get(part, {}).keys():
      gas_usage[gas] = tree_type.gas_usage[part][gas] + gas_usage.get(gas, 0.0);
    for mat in tree_type.material_production.get(part, {}).keys():
      material_production[mat] = tree_type.material_production[part][mat] + material_production.get(mat, 0.0);
    for gas in tree_type.gas_production.get(part, {}).keys():
      gas_production[gas] = tree_type.gas_production[part][gas] + gas_production.get(gas, 0.0);

  for mat in material_usage.keys():
    var val = material_usage[mat];
    if val > 0:
      tooltip += str('\nNeeds ', val, " ", mat, " per sec");
  for gas in gas_usage.keys():
    var val = gas_usage[gas];
    if val > 0:
      tooltip += str('\nNeeds ', val, " ", gas, " per sec");
  for mat in material_production.keys():
    var val = material_production[mat];
    if val > 0:
      tooltip += str('\nProduces ', val, " ", mat, " per sec");
  for gas in gas_production.keys():
    var val = gas_production[gas];
    if val > 0:
      tooltip += str('\nProduces ', val, " ", gas, " per sec");
  texture.set_tooltip_text(tooltip);
  var label = get_node("Name");
  label.set_text(tree_type.name);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass

func _on_texture_pressed():
  pressed.emit(tree_type);
