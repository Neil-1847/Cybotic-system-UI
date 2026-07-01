extends Control
class_name HumanoidView

var cyborg_manager: CyborgManager
var body_parts_rect: Dictionary = {}
var hover_body_part: GameConstants.BodyPart = -1

signal body_part_selected(body_part: GameConstants.BodyPart)

func _ready():
	if get_parent() is CyborgManager:
		cyborg_manager = get_parent()
	else:
		for node in get_tree().get_nodes_in_group("cyborg_manager"):
			cyborg_manager = node
			break
	
	if cyborg_manager:
		cyborg_manager.module_added.connect(queue_redraw)
		cyborg_manager.module_removed.connect(queue_redraw)
		
	gui_input.connect(_on_gui_input)
	mouse_moved.connect(queue_redraw)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_local_mouse_position()
		for body_part in body_parts_rect:
			if body_parts_rect[body_part].has_point(mouse_pos):
				if cyborg_manager:
					cyborg_manager.switch_body_part(body_part)
					body_part_selected.emit(body_part)
				queue_redraw()
				return

func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var found = false
	for body_part in body_parts_rect:
		if body_parts_rect[body_part].has_point(mouse_pos):
			hover_body_part = body_part
			found = true
			break
	if not found:
		hover_body_part = -1

func _draw():
	var center = size / 2
	var scale_factor = 2.0
	
	# Draw head
	var head_rect = Rect2(center - Vector2(20, 50), Vector2(40, 40))
	body_parts_rect[GameConstants.BodyPart.HEAD] = head_rect
	draw_body_part(head_rect, GameConstants.BodyPart.HEAD)
	
	# Draw torso
	var torso_rect = Rect2(center - Vector2(30, 10), Vector2(60, 60))
	body_parts_rect[GameConstants.BodyPart.TORSO] = torso_rect
	draw_body_part(torso_rect, GameConstants.BodyPart.TORSO)
	
	# Draw left arm
	var left_arm_rect = Rect2(center - Vector2(50, 0), Vector2(20, 50))
	body_parts_rect[GameConstants.BodyPart.LEFT_ARM] = left_arm_rect
	draw_body_part(left_arm_rect, GameConstants.BodyPart.LEFT_ARM)
	
	# Draw right arm
	var right_arm_rect = Rect2(center + Vector2(30, -25), Vector2(20, 50))
	body_parts_rect[GameConstants.BodyPart.RIGHT_ARM] = right_arm_rect
	draw_body_part(right_arm_rect, GameConstants.BodyPart.RIGHT_ARM)
	
	# Draw left leg
	var left_leg_rect = Rect2(center - Vector2(25, 70), Vector2(20, 60))
	body_parts_rect[GameConstants.BodyPart.LEFT_LEG] = left_leg_rect
	draw_body_part(left_leg_rect, GameConstants.BodyPart.LEFT_LEG)
	
	# Draw right leg
	var right_leg_rect = Rect2(center + Vector2(5, -70), Vector2(20, 60))
	body_parts_rect[GameConstants.BodyPart.RIGHT_LEG] = right_leg_rect
	draw_body_part(right_leg_rect, GameConstants.BodyPart.RIGHT_LEG)

func draw_body_part(rect: Rect2, body_part: GameConstants.BodyPart):
	var is_current = cyborg_manager and cyborg_manager.current_body_part == body_part
	var is_hover = hover_body_part == body_part
	
	var color = Color(0.3, 0.3, 0.3)
	if is_current:
		color = Color.CYAN
	elif is_hover:
		color = Color.GRAY
	
	draw_rect(rect, color)
	draw_rect(rect, Color.WHITE, false, 2.0 if is_hover or is_current else 1.0)
	
	# Draw body part name
	var name_text = GameConstants.BODY_PART_NAMES[body_part]
	draw_string(ThemeDB.fallback_font, rect.position + rect.size / 2, name_text, 
			HORIZONTAL_ALIGNMENT_CENTER, -1, 12, Color.WHITE)
