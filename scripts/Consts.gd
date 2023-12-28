class_name GDConsts;

enum MATERIAL {Phosphorus, Potassium, Calcium, COUNT};
const MATERIAL_NAME: Array[String] = ["phosphorus", "potassium", "calcium"];
const MATERIAL_NAMEC: Array[String] = ["Phosphorus", "Potassium", "Calcium"];

enum GAS {Nitrogen, Oxygen, Carbondioxide, COUNT};
const GAS_NAME: Array[String] = ["nitrogen", "oxygen", "carbondioxide"];
const GAS_NAMEC: Array[String] = ["Nitrogen", "Oxygen", "Carbondioxide"];

enum PHYSICS_LAYERS {Terrain = 1, Plant = 2};

const RAY_LENGTH: int = 200;
const GRID_COUNT_PER_EDGE: int = 20;
