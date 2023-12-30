class_name GDConsts;

enum MATERIAL {Phosphorus, Potassium, Calcium, Water, COUNT};
const MATERIAL_NAME: Array[String] = ["phosphorus", "potassium", "calcium", "water"];
const MATERIAL_NAMEC: Array[String] = ["Phosphorus", "Potassium", "Calcium", "Water"];
const MATERIAL_ICON: Array[String] = ["res://textures/img_phosphorus.png", "res://textures/img_potassium.png", "res://textures/img_calcium.png", "res://textures/img_water.png"];

enum GAS {Nitrogen, Oxygen, Carbondioxide, COUNT};
const GAS_NAME: Array[String] = ["nitrogen", "oxygen", "carbondioxide"];
const GAS_NAMEC: Array[String] = ["Nitrogen", "Oxygen", "Carbondioxide"];
const GAS_ICON: Array[String] = ["res://textures/img_nitrogen.png", "res://textures/img_oxygen.png", "res://textures/img_carbondioxide.png"];

enum PHYSICS_LAYERS {Terrain = 1, Plant = 2};

const RAY_LENGTH: int = 200;
const CELL_COUNT_PER_EDGE: int = 20;
const GRID_LINE_COUNT_PER_CELL_EDGE = 4;

enum PLANT_PART {Body, Branch, Leaf, Fruit};
const PLANT_PART_NAME: Array[String] = ["body", "branch", "leaf", "fruit"];
