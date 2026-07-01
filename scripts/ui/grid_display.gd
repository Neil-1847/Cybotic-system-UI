extends Control
class_name GridDisplay

var grid_size: Vector2i
var cell_size: int = 32
var selected_module = null
var dragging: bool = false

signal module_selected
signal module_deselected

func _ready():
	grid_size = Vector2i(8, 8)
	queue_redraw()

func _draw():
	var grid_rect = Rect2(Vector2.ZERO, grid_size * cell_size)
	draw_rect(grid_rect, Color(0.1, 0.1, 0.1))
	draw_rect(grid_rect, Color.GRAY, false, 2.0)
	
	for x in range(grid_size.x + 1):
		draw_line(Vector2(x * cell_size, 0), Vector2(x * cell_size, grid_size.y * cell_size), Color(0.3, 0.3, 0.3))
	for y in range(grid_size.y + 1):
		draw_line(Vector2(0, y * cell_size), Vector2(grid_size.x * cell_size, y * cell_size), Color(0.3, 0.3, 0.3))
