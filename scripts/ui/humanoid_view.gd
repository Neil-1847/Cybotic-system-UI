extends Control
class_name HumanoidView

var body_parts_rect: Dictionary = {}
var hover_body_part: int = -1

signal body_part_selected(body_part: int)

func _ready():
	gui_input.connect(_on_gui_input)
	queue_redraw()

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_local_mouse_position()
		for body_part in body_parts_rect:
			if body_parts_rect[body_part].has_point(mouse_pos):
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
	
	var head_rect = Rect2(center - Vector2(20, 50), Vector2(40, 40))
	body_parts_rect[0] = head_rect
	draw_body_part(head_rect, 0)
	
	var torso_rect = Rect2(center - Vector2(30, 10), Vector2(60, 60))
	body_parts_rect[1] = torso_rect
	draw_body_part(torso_rect, 1)
	
	var left_arm_rect = Rect2(center - Vector2(50, 0), Vector2(20, 50))
	body_parts_rect[2] = left_arm_rect
	draw_body_part(left_arm_rect, 2)
	
	var right_arm_rect = Rect2(center + Vector2(30, -25), Vector2(20, 50))
	body_parts_rect[3] = right_arm_rect
	draw_body_part(right_arm_rect, 3)
	
	var left_leg_rect = Rect2(center - Vector2(25, 70), Vector2(20, 60))
	body_parts_rect[4] = left_leg_rect
	draw_body_part(left_leg_rect, 4)
	
	var right_leg_rect = Rect2(center + Vector2(5, -70), Vector2(20, 60))
	body_parts_rect[5] = right_leg_rect
	draw_body_part(right_leg_rect, 5)

func draw_body_part(rect: Rect2, body_part: int):
	var is_hover = hover_body_part == body_part
	
	var color = Color(0.3, 0.3, 0.3)
	if is_hover:
		color = Color.GRAY
	
	draw_rect(rect, color)
	draw_rect(rect, Color.WHITE, false, 2.0 if is_hover else 1.0)
