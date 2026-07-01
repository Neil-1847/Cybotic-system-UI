extends PanelContainer
class_name ModuleSelector

@onready var module_container = VBoxContainer.new()
var cyborg_manager: CyborgManager
var selected_module_type: GameConstants.ModuleType
var selected_shape: String = "I"

signal module_selected(module_type: GameConstants.ModuleType, shape: String)

func _ready():
	if get_parent() is CyborgManager:
		cyborg_manager = get_parent()
	else:
		for node in get_tree().get_nodes_in_group("cyborg_manager"):
			cyborg_manager = node
			break
	
	add_child(module_container)
	_create_module_buttons()

func _create_module_buttons():
	module_container.clear()
	
	for module_type in GameConstants.ModuleType.values():
		var hbox = HBoxContainer.new()
		module_container.add_child(hbox)
		
		# Module type button
		var color_button = Button.new()
		color_button.text = GameConstants.MODULE_NAMES[module_type]
		color_button.modulate = GameConstants.MODULE_COLORS[module_type]
		color_button.pressed.connect(_on_module_type_selected.bind(module_type))
		hbox.add_child(color_button)
		
		# Add info label
		var info_label = Label.new()
		info_label.text = GameConstants.MODULE_DESCRIPTIONS[module_type]
		info_label.clip_text = true
		hbox.add_child(info_label)
		hbox.set_split_offset(150)

func _on_module_type_selected(module_type: GameConstants.ModuleType):
	selected_module_type = module_type
	module_selected.emit(module_type, selected_shape)

func get_selected_module() -> Dictionary:
	return {
		"type": selected_module_type,
		"shape": selected_shape
	}
