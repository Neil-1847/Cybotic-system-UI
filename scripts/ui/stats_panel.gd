extends PanelContainer
class_name StatsPanel

@onready var stats_container = VBoxContainer.new()
var current_stats: StatsCalculator.CyborgStats
var stats_calculator: StatsCalculator

func _ready():
	stats_calculator = StatsCalculator.new()
	add_child(stats_container)
	
	var title = Label.new()
	title.text = "義體屬性"
	title.add_theme_font_size_override("font_size", 20)
	stats_container.add_child(title)
	
	var separator = HSeparator.new()
	stats_container.add_child(separator)

func update_stats(stats: StatsCalculator.CyborgStats):
	current_stats = stats
	_refresh_display()

func _refresh_display():
	# Clear existing labels
	for child in stats_container.get_children():
		if child is Label and child != stats_container.get_child(0):
			child.queue_free()
	
	if not current_stats:
		return
	
	var stats_dict = current_stats.to_dict()
	
	for stat_name in stats_dict:
		var value = stats_dict[stat_name]
		var display_name = stats_calculator.get_stat_display_name(stat_name)
		var unit = stats_calculator.get_stat_unit(stat_name)
		
		var label = Label.new()
		label.text = "%s: %.1f%s" % [display_name, value, unit]
		stats_container.add_child(label)
	
	# Add abilities section
	var separator = HSeparator.new()
	stats_container.add_child(separator)
	
	var abilities_title = Label.new()
	abilities_title.text = "特殊能力"
	abilities_title.add_theme_font_size_override("font_size", 16)
	stats_container.add_child(abilities_title)
	
	var abilities = stats_calculator.get_abilities_description(current_stats)
	for ability in abilities:
		var ability_label = Label.new()
		ability_label.text = ability
		ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		stats_container.add_child(ability_label)
