class_name GDWinningConditions;

# These are normalized values (i.e. use 0.1 for 10%)
var min_air_contents: Dictionary;
var max_air_contents: Dictionary;
# TODO: this should check growth too, but how to do it fast?
# Can integrate to the existing tree iteration in GDLevel
# like storing a mature_plant_count that resets every sec
var min_plant_count: Dictionary;
var max_plant_count: Dictionary;

func player_won(level: GDLevel, plant_count: Dictionary):
  var air_contents = level.air.get_normalized();
  for air in min_air_contents.keys():
    if air_contents[air] < min_air_contents[air]:
      return false;
  for air in max_air_contents.keys():
    if air_contents[air] > max_air_contents[air]:
      return false;
  for tree in min_plant_count.keys():
    if plant_count.get(tree, 0) < min_plant_count[tree]:
      return false;
  for tree in max_plant_count.keys():
    if plant_count.get(tree, 0) > max_plant_count[tree]:
      return false;
  return true;

func get_progress_message(level: GDLevel, plant_count: Dictionary):
  var msg: String = '';
  var air_contents = level.air.get_normalized();
  for gas_id in GDConsts.GAS.COUNT:
    var gas = GDConsts.GAS_NAME[gas_id];
    if gas in min_air_contents:
      msg += str('[imgresize=32]', GDConsts.GAS_ICON[gas_id], '[/imgresize] > ', min_air_contents[gas] * 100, '%');
      if air_contents[gas] < min_air_contents[gas]:
        msg += str('[imgresize=32]res://textures/cross.png[/imgresize]');
      else:
        msg += str('[imgresize=32]res://textures/tick.png[/imgresize]');
      msg += '\n';
    if gas in max_air_contents:
      msg += str('[imgresize=32]', GDConsts.GAS_ICON[gas_id], '[/imgresize] < ', max_air_contents[gas] * 100, '%');
      if air_contents[gas] > max_air_contents[gas]:
        msg += str('[imgresize=32]res://textures/cross.png[/imgresize]');
      else:
        msg += str('[imgresize=32]res://textures/tick.png[/imgresize]');
      msg += '\n';

  for tree in min_plant_count.keys():
    var cnt = plant_count.get(tree, 0);
    msg += str(tree, ': ', cnt, ' > ', min_plant_count[tree])
    if cnt < min_plant_count[tree]:
      msg += str('[imgresize=32]res://textures/cross.png[/imgresize]');
    else:
      msg += str('[imgresize=32]res://textures/tick.png[/imgresize]');
    msg += '\n';
  for tree in max_plant_count.keys():
    var cnt = plant_count.get(tree, 0);
    msg += str(tree, ': ', cnt, ' < ', max_plant_count[tree])
    if cnt > max_plant_count[tree]:
      msg += str('[imgresize=32]res://textures/cross.png[/imgresize]');
    else:
      msg += str('[imgresize=32]res://textures/tick.png[/imgresize]');
  return msg;
  
