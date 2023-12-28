class_name GDWinningConditions;

# These are normalized values (i.e. use 0.1 for 10%)
var min_air_contents: Dictionary;
var max_air_contents: Dictionary;
# TODO: this should check growth too, but how to do it fast?
# Can integrate to the existing tree iteration in GDLevel
# like storing a mature_plant_count that resets every sec
var min_plant_count: Dictionary;
var max_plant_count: Dictionary;

func player_won(level: GDLevel):
  var air_contents = level.air.get_normalized();
  for air in min_air_contents.keys():
    if air_contents[air] < min_air_contents[air]:
      return false;
  for air in max_air_contents.keys():
    if air_contents[air] > max_air_contents[air]:
      return false;
  for tree in min_plant_count.keys():
    if level.plant_count.get(tree, 0) < min_plant_count[tree]:
      return false;
  for tree in max_plant_count.keys():
    if level.plant_count.get(tree, 0) > max_plant_count[tree]:
      return false;
  return true;
