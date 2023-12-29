class_name GDConsts;

enum MATERIAL {Phosphorus, Potassium, Calcium, Water, COUNT};
const MATERIAL_NAME: Array[String] = ["phosphorus", "potassium", "calcium", "water"];
const MATERIAL_NAMEC: Array[String] = ["Phosphorus", "Potassium", "Calcium", "Water"];

enum GAS {Nitrogen, Oxygen, Carbondioxide, COUNT};
const GAS_NAME: Array[String] = ["nitrogen", "oxygen", "carbondioxide"];
const GAS_NAMEC: Array[String] = ["Nitrogen", "Oxygen", "Carbondioxide"];

enum PHYSICS_LAYERS {Terrain = 1, Plant = 2};

const RAY_LENGTH: int = 200;
const CELL_COUNT_PER_EDGE: int = 20;

enum PLANT_PART {Body, Branch, Leaf, Fruit};
const PLANT_PART_NAME: Array[String] = ["body", "branch", "leaf", "fruit"];
