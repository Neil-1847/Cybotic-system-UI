extends Node
class_name ModuleSystem

# Module class to represent individual modules
class Module:
	var module_type: GameConstants.ModuleType
	var shape_name: String
	var rotation_index: int = 0
	var position: Vector2i
	var cells: Array
	
	func _init(p_type: GameConstants.ModuleType, p_shape: String, p_pos: Vector2i = Vector2i.ZERO):
		module_type = p_type
		shape_name = p_shape
		position = p_pos
		update_cells()
	
	func update_cells():
		var tetromino = TetrominoShapes.new()
		var rotations = tetromino.get_shape_rotations(shape_name)
		if rotation_index < rotations.size():
			cells = rotations[rotation_index].duplicate()
	
	func get_color() -> Color:
		return GameConstants.MODULE_COLORS[module_type]
	
	func get_name() -> String:
		return GameConstants.MODULE_NAMES[module_type]
	
	func get_description() -> String:
		return GameConstants.MODULE_DESCRIPTIONS[module_type]
	
	func get_world_cells() -> Array:
		var world_cells = []
		for cell in cells:
			world_cells.append(position + cell)
		return world_cells
	
	func rotate():
		var tetromino = TetrominoShapes.new()
		var rotations = tetromino.get_shape_rotations(shape_name)
		rotation_index = (rotation_index + 1) % rotations.size()
		update_cells()
	
	func get_bounding_box() -> Vector2i:
		var tetromino = TetrominoShapes.new()
		var rotations = tetromino.get_shape_rotations(shape_name)
		if rotation_index < rotations.size():
			return tetromino.get_bounding_box(rotations[rotation_index])
		return Vector2i.ZERO

# ModuleSystem class
var modules: Array = []
var module_id_counter: int = 0

func _ready():
	pass

# Add a new module
func add_module(module_type: GameConstants.ModuleType, shape_name: String, position: Vector2i) -> Module:
	var module = Module.new(module_type, shape_name, position)
	modules.append(module)
	return module

# Remove module by index
func remove_module(index: int):
	if index >= 0 and index < modules.size():
		modules.remove_at(index)

# Get all modules
func get_modules() -> Array:
	return modules

# Get module at specific world position
func get_module_at(world_pos: Vector2i) -> Module:
	for module in modules:
		if world_pos in module.get_world_cells():
			return module
	return null

# Check if position is occupied
func is_occupied(world_pos: Vector2i) -> bool:
	return get_module_at(world_pos) != null

# Get all occupied cells
func get_occupied_cells() -> Array:
	var occupied = []
	for module in modules:
		for cell in module.get_world_cells():
			occupied.append(cell)
	return occupied

# Clear all modules
func clear_modules():
	modules.clear()

# Get modules by type
func get_modules_by_type(module_type: GameConstants.ModuleType) -> Array:
	var result = []
	for module in modules:
		if module.module_type == module_type:
			result.append(module)
	return result

# Move module
func move_module(module: Module, new_pos: Vector2i):
	module.position = new_pos

# Rotate module
func rotate_module(module: Module):
	module.rotate()

# Get total occupied space
func get_total_occupied_cells() -> int:
	var occupied = {}
	for module in modules:
		for cell in module.get_world_cells():
			occupied[cell] = true
	return occupied.size()
