extends Node
class_name MainUI

@onready var grid_display: GridDisplay
@onready var stats_panel: StatsPanel
@onready var module_selector: ModuleSelector
@onready var humanoid_view: HumanoidView

var cyborg_manager: CyborgManager
var selected_module_type: GameConstants.ModuleType = GameConstants.ModuleType.COOLING
var selected_shape: String = "I"

func _ready():
	cyborg_manager = CyborgManager.new()
	add_child(cyborg_manager)
	cyborg_manager.add_to_group("cyborg_manager")
	cyborg_manager._ready()
	
	# Create main layout
	var main_container = HBoxContainer.new()
	main_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_container)
	
	# Left side: Humanoid view
	var left_panel = PanelContainer.new()
	left_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	left_panel.custom_minimum_size = Vector2(200, 600)
	main_container.add_child(left_panel)
	
	humanoid_view = HumanoidView.new()
	humanoid_view.cyborg_manager = cyborg_manager
	left_panel.add_child(humanoid_view)
	humanoid_view.body_part_selected.connect(_on_body_part_selected)
	
	# Center: Grid display
	var center_panel = PanelContainer.new()
	center_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.add_child(center_panel)
	
	grid_display = GridDisplay.new()
	grid_display.cyborg_manager = cyborg_manager
	center_panel.add_child(grid_display)
	grid_display._ready()
	cyborg_manager.module_added.connect(_on_module_added)
	
	# Right side: Stats and Module selector
	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	right_vbox.custom_minimum_size = Vector2(300, 0)
	main_container.add_child(right_vbox)
	
	# Stats panel
	stats_panel = StatsPanel.new()
	stats_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_child(stats_panel)
	cyborg_manager.stats_updated.connect(_on_stats_updated)
	
	# Module selector
	var selector_label = Label.new()
	selector_label.text = "選擇模組"
	selector_label.add_theme_font_size_override("font_size", 16)
	right_vbox.add_child(selector_label)
	
	module_selector = ModuleSelector.new()
	module_selector.cyborg_manager = cyborg_manager
	right_vbox.add_child(module_selector)
	module_selector._ready()
	module_selector.module_selected.connect(_on_module_type_selected)
	
	# Shape selector
	var shape_label = Label.new()
	shape_label.text = "俄羅斯方塊形狀"
	shape_label.add_theme_font_size_override("font_size", 14)
	right_vbox.add_child(shape_label)
	
	var shape_hbox = HBoxContainer.new()
	right_vbox.add_child(shape_hbox)
	
	var tetromino = TetrominoShapes.new()
	for shape in tetromino.get_all_shapes():
		var shape_btn = Button.new()
		shape_btn.text = shape
		shape_btn.pressed.connect(_on_shape_selected.bind(shape))
		shape_hbox.add_child(shape_btn)
	
	# Initialize stats
	_on_stats_updated(cyborg_manager.stats_calculator.calculate_stats([]))

func _on_stats_updated(stats: StatsCalculator.CyborgStats):
	if stats_panel:
		stats_panel.update_stats(stats)

func _on_module_type_selected(module_type: GameConstants.ModuleType, _shape: String):
	selected_module_type = module_type

func _on_shape_selected(shape: String):
	selected_shape = shape

func _on_body_part_selected(body_part: GameConstants.BodyPart):
	print("Selected body part: %s" % GameConstants.BODY_PART_NAMES[body_part])

func _on_module_added(module: ModuleSystem.Module):
	print("Module added: %s at %v" % [module.get_name(), module.position])

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		if grid_display.get_global_rect().has_point(mouse_pos):
			var local_mouse = grid_display.get_local_mouse_position()
			var grid_pos = grid_display.world_to_grid(local_mouse)
			
			# Try to add new module
			if cyborg_manager.add_module(selected_module_type, selected_shape, grid_pos):
				grid_display.queue_redraw()
