extends Control
class_name GridDisplay

@onready var cyborg_manager: CyborgManager
var grid_size: Vector2i
var cell_size: int = GameConstants.GRID_CELL_SIZE
var selected_module: ModuleSystem.Module = null
var dragging: bool = false
var drag_offset: Vector2i = Vector2i.ZERO
var preview_position: Vector2i = Vector2i.ZERO

signal module_selected(module: ModuleSystem.Module)
signal module_deselected()

func _ready():
	if get_parent() is CyborgManager:
		cyborg_manager = get_parent()
	else:
		for node in get_tree().get_nodes_in_group("cyborg_manager"):
			cyborg_manager = node
			break
	
	if cyborg_manager:
		cyborg_manager.body_part_changed.connect(_on_body_part_changed)
		cyborg_manager.module_added.connect(queue_redraw)
		cyborg_manager.module_removed.connect(queue_redraw)
		cyborg_manager.stats_updated.connect(func(_stats): queue_redraw())
		grid_size = cyborg_manager.get_grid_size()
	
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_body_part_changed(body_part: GameConstants.BodyPart):
	grid_size = cyborg_manager.get_grid_size()
	selected_module = null
	module_deselected.emit()
	queue_redraw()

func _on_gui_input(event: InputEvent):
	if not cyborg_manager:
		return
	
	if event is InputEventMouseButton:
		var mouse_pos = get_local_mouse_position()
		var grid_pos = world_to_grid(mouse_pos)
		
		if event.pressed:
			# Try to select a module
			var module = cyborg_manager.get_occupied_cells()
			var modules = cyborg_manager.get_modules()
			for mod in modules:
				if grid_pos in mod.get_world_cells():
					selected_module = mod
					drag_offset = grid_pos - mod.position
					dragging = true
					module_selected.emit(mod)
					queue_redraw()
					return
			
			# No module selected
			selected_module = null
			module_deselected.emit()
			queue_redraw()
		else:
			dragging = false
	
	elif event is InputEventMouseMotion and dragging and selected_module:
		var mouse_pos = get_local_mouse_position()
		preview_position = world_to_grid(mouse_pos) - drag_offset
		queue_redraw()

elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_R and selected_module:
			cyborg_manager.rotate_module(selected_module)
			queue_redraw()
		elif event.keycode == KEY_DELETE and selected_module:
			cyborg_manager.remove_module(selected_module)
			selected_module = null
			module_deselected.emit()
			queue_redraw()

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	if dragging:
		dragging = false

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(int(world_pos.x / cell_size), int(world_pos.y / cell_size))

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)

func _draw():
	if not cyborg_manager:
		return
	
	# Draw grid
	var grid_rect = Rect2(Vector2.ZERO, grid_size * cell_size)
	draw_rect(grid_rect, Color(0.1, 0.1, 0.1))
	draw_rect(grid_rect, Color.GRAY, false, 2.0)
	
	# Draw grid lines
	for x in range(grid_size.x + 1):
		draw_line(Vector2(x * cell_size, 0), Vector2(x * cell_size, grid_size.y * cell_size), Color(0.3, 0.3, 0.3))
	for y in range(grid_size.y + 1):
		draw_line(Vector2(0, y * cell_size), Vector2(grid_size.x * cell_size, y * cell_size), Color(0.3, 0.3, 0.3))
	
	# Draw modules
	for module in cyborg_manager.get_modules():
		draw_module(module, module == selected_module)
	
	# Draw preview while dragging
	if dragging and selected_module:
		draw_module_preview(selected_module, preview_position)

func draw_module(module: ModuleSystem.Module, is_selected: bool = false):
	var color = module.get_color()
	if is_selected:
		color = color.lightened(0.3)
	
	for cell in module.get_world_cells():
		var world_pos = grid_to_world(cell)
		draw_rect(Rect2(world_pos, Vector2(cell_size, cell_size)), color)
		draw_rect(Rect2(world_pos, Vector2(cell_size, cell_size)), Color.BLACK, false, 1.0)
	
	if is_selected:
		# Draw selection border
		var bbox_pos = grid_to_world(module.position)
		var bbox_size = module.get_bounding_box() * cell_size
		draw_rect(Rect2(bbox_pos, bbox_size), Color.WHITE, false, 2.0)

func draw_module_preview(module: ModuleSystem.Module, grid_pos: Vector2i):
	var tetromino = TetrominoShapes.new()
	var can_place = tetromino.can_place_shape(module.cells, grid_pos, grid_size) and \
				   not tetromino.check_collision(module.cells, grid_pos, get_other_occupied_cells())
	
	var color = module.get_color()
	if can_place:
		color = color.lightened(0.2)
		color.a = 0.6
	else:
		color = Color.RED
		color.a = 0.4
	
	for cell in module.cells:
		var world_pos = grid_to_world(grid_pos + cell)
		if world_pos.x + cell_size <= grid_size.x * cell_size and world_pos.y + cell_size <= grid_size.y * cell_size:
			draw_rect(Rect2(world_pos, Vector2(cell_size, cell_size)), color)

func get_other_occupied_cells() -> Array:
	var occupied = []
	for module in cyborg_manager.get_modules():
		if module != selected_module:
			for cell in module.get_world_cells():
				occupied.append(cell)
	return occupied

func get_size() -> Vector2:
	return Vector2(grid_size * cell_size)
