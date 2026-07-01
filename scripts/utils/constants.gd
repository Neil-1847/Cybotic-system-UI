extends Node
class_name GameConstants

# Module Types
enum ModuleType {
	COOLING,      # 冷卻型 - 淺藍色
	OVERLOAD,     # 超載型 - 紅色
	POWER,        # 能源型 - 黃色
	DEFENSE,      # 防禦型 - 綠色
	PROCESSING,   # 處理型 - 紫色
	REINFORCED    # 強化型 - 橙色
}

# Module Type to Color mapping
const MODULE_COLORS = {
	ModuleType.COOLING: Color.LIGHT_BLUE,
	ModuleType.OVERLOAD: Color.RED,
	ModuleType.POWER: Color.YELLOW,
	ModuleType.DEFENSE: Color.GREEN,
	ModuleType.PROCESSING: Color.MAGENTA,
	ModuleType.REINFORCED: Color.ORANGE
}

# Module Type to Name mapping
const MODULE_NAMES = {
	ModuleType.COOLING: "冷卻型",
	ModuleType.OVERLOAD: "超載型",
	ModuleType.POWER: "能源型",
	ModuleType.DEFENSE: "防禦型",
	ModuleType.PROCESSING: "處理型",
	ModuleType.REINFORCED: "強化型"
}

# Module Type to Description
const MODULE_DESCRIPTIONS = {
	ModuleType.COOLING: "降低熱量產生，提升散熱效率",
	ModuleType.OVERLOAD: "增加能力輸出，但提高熱量產生",
	ModuleType.POWER: "增加能源供應和耗電管理",
	ModuleType.DEFENSE: "提升義體防禦和耐久性",
	ModuleType.PROCESSING: "提升計算能力和反應速度",
	ModuleType.REINFORCED: "全面強化義體結構"
}

# Cyborg Body Parts
enum BodyPart {
	HEAD,
	TORSO,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}

# Body Part to Grid Size mapping
const BODY_PART_GRID_SIZES = {
	BodyPart.HEAD: Vector2i(3, 3),
	BodyPart.TORSO: Vector2i(8, 8),
	BodyPart.LEFT_ARM: Vector2i(2, 6),
	BodyPart.RIGHT_ARM: Vector2i(2, 6),
	BodyPart.LEFT_LEG: Vector2i(2, 6),
	BodyPart.RIGHT_LEG: Vector2i(2, 6)
}

# Body Part Names
const BODY_PART_NAMES = {
	BodyPart.HEAD: "頭部",
	BodyPart.TORSO: "軀幹",
	BodyPart.LEFT_ARM: "左臂",
	BodyPart.RIGHT_ARM: "右臂",
	BodyPart.LEFT_LEG: "左腿",
	BodyPart.RIGHT_LEG: "右腿"
}

# Stats effect per module type
const MODULE_STAT_EFFECTS = {
	ModuleType.COOLING: {
		"heat_generation": -10,
		"cooling_efficiency": 15,
		"power_consumption": 5
	},
	ModuleType.OVERLOAD: {
		"heat_generation": 20,
		"output_power": 25,
		"power_consumption": 15
	},
	ModuleType.POWER: {
		"power_supply": 20,
		"power_consumption": -5,
		"energy_capacity": 30
	},
	ModuleType.DEFENSE: {
		"defense": 15,
		"durability": 20,
		"weight": 10
	},
	ModuleType.PROCESSING: {
		"processing_power": 20,
		"reaction_speed": 15,
		"power_consumption": 10
	},
	ModuleType.REINFORCED: {
		"overall_efficiency": 10,
		"durability": 10,
		"weight": 5
	}
}

# Grid cell size in pixels
const GRID_CELL_SIZE = 40

# Module preview sizes
const MODULE_PREVIEW_SIZE = 30
