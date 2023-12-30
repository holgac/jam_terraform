extends Node3D

var state: int = 0;

func _on_back_pressed():
  Session.goto_scene(Session.MainMenuScene);

func _ready():
  randomize();
  for child in get_node('Trees').get_children():
    for part in GDConsts.PLANT_PART_NAME:
      child.get_node(part).hide();
  for child in get_node('Credits').get_children():
    child.hide();

func _on_timer_timeout():
  if state == GDConsts.PLANT_PART.COUNT:
    var positions: Array[Vector3] = [];
    for child in get_node('Credits').get_children():
      positions.append(child.position);
    for child in get_node('Credits').get_children():
      var idx = randi() % positions.size();
      var pos = positions[idx];
      positions.remove_at(idx);
      child.position = pos;
      child.show();
    get_node('Timer').stop();
    return;
  var part: String = GDConsts.PLANT_PART_NAME[state];
  for child in get_node('Trees').get_children():
    child.get_node(part).show();
  state += 1;
