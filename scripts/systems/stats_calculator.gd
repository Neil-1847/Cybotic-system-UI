extends Node
class_name StatsCalculator

# Stats data structure
class CyborgStats:
	var heat_generation: float = 0.0
	var cooling_efficiency: float = 100.0
	var power_consumption: float = 0.0
	var power_supply: float = 0.0
	var energy_capacity: float = 0.0
	var output_power: float = 0.0
	var defense: float = 0.0
	var durability: float = 0.0
	var processing_power: float = 0.0
	var reaction_speed: float = 0.0
	var overall_efficiency: float = 100.0
	var weight: float = 0.0
	
	# Module count tracking
	var module_count: Dictionary = {}
	var total_modules: int = 0
	
	func _init():
		for module_type in GameConstants.ModuleType.values():
			module_count[module_type] = 0
	
	func to_dict() -> Dictionary:
		return {
			"heat_generation": heat_generation,
			"cooling_efficiency": cooling_efficiency,
			"power_consumption": power_consumption,
			"power_supply": power_supply,
			"energy_capacity": energy_capacity,
			"output_power": output_power,
			"defense": defense,
			"durability": durability,
			"processing_power": processing_power,
			"reaction_speed": reaction_speed,
			"overall_efficiency": overall_efficiency,
			"weight": weight,
			"total_modules": total_modules
		}

# Calculate stats from module list
func calculate_stats(modules: Array) -> CyborgStats:
	var stats = CyborgStats.new()
	
	# Base stats
	stats.cooling_efficiency = 100.0
	stats.overall_efficiency = 100.0
	
	# Count and calculate from each module
	for module in modules:
		stats.total_modules += 1
		stats.module_count[module.module_type] += 1
		
		# Apply module effects
		if module.module_type in GameConstants.MODULE_STAT_EFFECTS:
			var effects = GameConstants.MODULE_STAT_EFFECTS[module.module_type]
			
			for stat_name in effects:
				var effect_value = effects[stat_name]
				match stat_name:
					"heat_generation":
						stats.heat_generation += effect_value
					"cooling_efficiency":
						stats.cooling_efficiency += effect_value
					"power_consumption":
						stats.power_consumption += effect_value
					"power_supply":
						stats.power_supply += effect_value
					"energy_capacity":
						stats.energy_capacity += effect_value
					"output_power":
						stats.output_power += effect_value
					"defense":
						stats.defense += effect_value
					"durability":
						stats.durability += effect_value
					"processing_power":
						stats.processing_power += effect_value
					"reaction_speed":
						stats.reaction_speed += effect_value
					"overall_efficiency":
						stats.overall_efficiency += effect_value * 0.5
					"weight":
						stats.weight += effect_value
	
	# Ensure positive values for certain stats
	stats.cooling_efficiency = max(50.0, stats.cooling_efficiency)
	stats.heat_generation = max(0.0, stats.heat_generation)
	stats.overall_efficiency = max(50.0, stats.overall_efficiency)
	
	return stats

# Get stat display name
func get_stat_display_name(stat_name: String) -> String:
	var names = {
		"heat_generation": "熱量產生",
		"cooling_efficiency": "冷卻效率",
		"power_consumption": "耗電量",
		"power_supply": "能源供應",
		"energy_capacity": "能量容量",
		"output_power": "輸出功率",
		"defense": "防禦力",
		"durability": "耐久性",
		"processing_power": "處理能力",
		"reaction_speed": "反應速度",
		"overall_efficiency": "整體效率",
		"weight": "重量",
		"total_modules": "總模組數"
	}
	return names.get(stat_name, stat_name)

# Get stat unit
func get_stat_unit(stat_name: String) -> String:
	var units = {
		"heat_generation": " °C/s",
		"cooling_efficiency": " %",
		"power_consumption": " W",
		"power_supply": " W",
		"energy_capacity": " kJ",
		"output_power": " %",
		"defense": " pts",
		"durability": " pts",
		"processing_power": " GFLOPS",
		"reaction_speed": " ms",
		"overall_efficiency": " %",
		"weight": " kg"
	}
	return units.get(stat_name, "")

# Get ability description based on stats
func get_abilities_description(stats: CyborgStats) -> Array:
	var abilities = []
	
	# Heat management ability
	if stats.cooling_efficiency > 150:
		abilities.append("【高效散熱】冷卻系統超效能運作")
	elif stats.cooling_efficiency > 100:
		abilities.append("【散熱優化】冷卻系統工作穩定")
	
	# Power management ability
	if stats.power_supply > 100:
		abilities.append("【強力供能】能源供應充足")
	elif stats.energy_capacity > 200:
		abilities.append("【能量儲備】大容量能量儲存")
	
	# Output ability
	if stats.output_power > 50:
		abilities.append("【超載輸出】能力輸出大幅提升")
	
	# Processing ability
	if stats.processing_power > 50:
		abilities.append("【高速計算】計算能力強大")
	
	# Defense ability
	if stats.defense > 50:
		abilities.append("【堅固外殼】防禦能力增強")
	
	# Efficiency ability
	if stats.overall_efficiency > 130:
		abilities.append("【整體優化】系統協調高效")
	
	# Heat warning
	if stats.heat_generation > 100:
		abilities.append("⚠️ 【過熱警告】熱量產生過多")
	
	return abilities if abilities.size() > 0 else ["【標準模式】基礎功能"]
