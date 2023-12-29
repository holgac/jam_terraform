class_name GDTreeType

var name: String = "UNNAMED TREE";
var trunk_growth_coef: float;
var branch_growth_coef: float;
var display_on_growth: Dictionary;
var texture: Texture2D;
var mesh: PackedScene;
var tooltip: String;
var material_usage: Dictionary;
var material_production: Dictionary;
var gas_usage: Dictionary;
var gas_production: Dictionary;

static func _from_json(data: Variant) -> GDTreeType:
  var res: GDTreeType = GDTreeType.new();
  res.name = data['name'] if 'name' in data else 'UNNAMED TREE';
  res.trunk_growth_coef = data['trunk_growth_coef'] if 'trunk_growth_coef' in data else 1.0;
  res.branch_growth_coef = data['branch_growth_coef'] if 'branch_growth_coef' in data else 1.0;

  for part in GDConsts.PARTS:
    res.display_on_growth[part] = 0.0

  if 'display' in data:
    var disp = data['display']
    for part in GDConsts.PARTS:
      if part in disp:
        res.display_on_growth[part] = disp[part];

  if 'material_usage' in data:
    var usage = data['material_usage']
    for u in usage.keys():
      res.material_usage[u] = usage[u].duplicate(true);
  if 'material_production' in data:
    var prod = data['material_production']
    for p in prod.keys():
      res.material_production[p] = prod[p].duplicate(true);
  if 'gas_usage' in data:
    var usage = data['gas_usage']
    for u in usage.keys():
      res.gas_usage[u] = usage[u].duplicate(true);
  if 'gas_production' in data:
    var prod = data['gas_production']
    for p in prod.keys():
      res.gas_production[p] = prod[p].duplicate(true);

  res.texture = ResourceLoader.load(data['texture'] if 'texture' in data else 'res://textures/tree1.png');
  res.mesh = ResourceLoader.load(data['mesh'] if 'mesh' in data else 'res://scenes/Tree1.tscn');
  res.tooltip = data['tooltip'] if 'tooltip' in data else 'NO INFO FOUND';
  return res
