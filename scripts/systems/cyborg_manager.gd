extends Node
class_name CyborgManager

signal stats_updated(stats: StatsCalculator.CyborgStats)
signal module_added(module: ModuleSystem.Module)
signal module_removed(module: ModuleSystem.Module)
signal body_part_changed(body_part: GameConstants.BodyPart)

var current_body_part: GameConstants.BodyPart = GameConstants.BodyPart.TORSO
var modules_by_body_part: Dictionary = {}
var current_grid_size: Vector2i

var stats_calculator: StatsCalculator

func _ready():
	stats_calculator = StatsCalculator.new()
	
	# Initialize modules dictionary for each body part
	for body_part in GameConstants.BodyPart.values():
		modules_by_body_part[body_part] = []
	
	switch_body_part(GameConstants.BodyPart.TORSO)

# Switch to a different body part
func switch_body_part(body_part: GameConstants.BodyPart):
	current_body_part = body_part
	current_grid_size = GameConstants.BODY_PART_GRID_SIZES[body_part]
	body_part_changed.emit(body_part)
	update_stats()

# Add module to current body part
func add_module(module_type: GameConstants.ModuleType, shape_name: String, position: Vector2i) -> bool:
	var tetromino = TetrominoShapes.new()
	var rotations = tetromino.get_shape_rotations(shape_name)
	if rotations.is_empty():
		return false
	
	# Check if module can be placed
	var module = ModuleSystem.Module.new(module_type, shape_name, position)
	if not tetromino.can_place_shape(module.cells, position, current_grid_size):
		return false
	
	if tetromino.check_collision(module.cells, position, get_occupied_cells()):
		return false
	
	# Add module
	modules_by_body_part[current_body_part].append(module)
	module_added.emit(module)
	update_stats()
	return true

# Remove module from current body part
func remove_module(module: ModuleSystem.Module) -> bool:
	if module in modules_by_body_part[current_body_part]:
		modules_by_body_part[current_body_part].erase(module)
		module_removed.emit(module)
		update_stats()
		return true
	return false

# Move module
func move_module(module: ModuleSystem.Module, new_pos: Vector2i) -> bool:
	var tetromino = TetrominoShapes.new()
	
	# Remove current position from occupied check
	var current_cells = module.get_world_cells()
	var other_occupied = get_occupied_cells()
	for cell in current_cells:
		other_occupied.erase(cell)
	
	# Check if new position is valid
	var new_cells = []
	for cell in module.cells:
		new_cells.append(new_pos + cell)
	
	if not tetromino.can_place_shape(module.cells, new_pos, current_grid_size):
		return false
	
	if tetromino.check_collision(module.cells, new_pos, other_occupied):
		return false
	
	# Move module
	module.position = new_pos
	update_stats()
	return true

# Rotate module
func rotate_module(module: ModuleSystem.Module) -> bool:
	if not module in get_modules():
		return false
	
	var tetromino = TetrominoShapes.new()
	var old_rotation = module.rotation_index
	var old_cells = module.cells.duplicate()
	
	# Try rotation
	module.rotate()
	
	# Check if new rotation is valid
	if not tetromino.can_place_shape(module.cells, module.position, current_grid_size):
		# Revert rotation
		module.rotation_index = old_rotation
		module.cells = old_cells
		return false
	
	# Remove current position from occupied check
	var current_cells = []
	for cell in old_cells:
		current_cells.append(module.position + cell)
	
	var other_occupied = get_occupied_cells()
	for cell in current_cells:
		other_occupied.erase(cell)
	
	if tetromino.check_collision(module.cells, module.position, other_occupied):
		# Revert rotation
		module.rotation_index = old_rotation
		module.cells = old_cells
		return false
	
	update_stats()
	return true

# Get all modules for current body part
func get_modules() -> Array:
	return modules_by_body_part[current_body_part]

# Get all modules for specific body part
func get_modules_for_body_part(body_part: GameConstants.BodyPart) -> Array:
	return modules_by_body_part[body_part]

# Get occupied cells for current body part
func get_occupied_cells() -> Array:
	var occupied = []
	for module in get_modules():
		for cell in module.get_world_cells():
			occupied.append(cell)
	return occupied

# Update and emit stats
func update_stats():
	var stats = stats_calculator.calculate_stats(get_modules())
	stats_updated.emit(stats)

# Clear all modules for current body part
func clear_modules():
	modules_by_body_part[current_body_part].clear()
	update_stats()

# Get grid size for current body part
func get_grid_size() -> Vector2i:
	return current_grid_size

# Get body part grid size
func get_body_part_grid_size(body_part: GameConstants.BodyPart) -> Vector2i:
	return GameConstants.BODY_PART_GRID_SIZES[body_part]
