extends Node
class_name TetrominoShapes

# Tetromino shape definitions
# Each shape is an array of relative positions (x, y) where the piece occupies cells
# Origin is at top-left of the bounding box

const SHAPES = {
	"I": [
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)],  # Horizontal
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3)]   # Vertical
	],
	"O": [
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]   # Always same
	],
	"T": [
		[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],  # Up
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)],  # Right
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1)],  # Down
		[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]   # Left
	],
	"S": [
		[Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)],  # Horizontal
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]   # Vertical
	],
	"Z": [
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)],  # Horizontal
		[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]   # Vertical
	],
	"J": [
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],  # Up
		[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(0, 2)],  # Right
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(2, 1)],  # Down
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(0, 2)]   # Left
	],
	"L": [
		[Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],  # Up
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)],  # Right
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1)],  # Down
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 2)]   # Left
	]
}

# Get all available shapes
func get_all_shapes() -> Array:
	return SHAPES.keys()

# Get specific shape rotations
func get_shape_rotations(shape_name: String) -> Array:
	if shape_name in SHAPES:
		return SHAPES[shape_name]
	return []

# Get bounding box for a shape
func get_bounding_box(cells: Array) -> Vector2i:
	if cells.is_empty():
		return Vector2i.ZERO
	
	var max_x = 0
	var max_y = 0
	for cell in cells:
		max_x = max(max_x, cell.x)
		max_y = max(max_y, cell.y)
	
	return Vector2i(max_x + 1, max_y + 1)

# Rotate shape 90 degrees clockwise
func rotate_shape_clockwise(cells: Array) -> Array:
	var rotated = []
	var bbox = get_bounding_box(cells)
	
	for cell in cells:
		# Rotation formula: (x, y) -> (height - 1 - y, x)
		var new_x = bbox.y - 1 - cell.y
		var new_y = cell.x
		rotated.append(Vector2i(new_x, new_y))
	
	return rotated

# Check if shape fits in grid at position
func can_place_shape(cells: Array, grid_pos: Vector2i, grid_size: Vector2i) -> bool:
	for cell in cells:
		var world_pos = grid_pos + cell
		if world_pos.x < 0 or world_pos.x >= grid_size.x or \
		   world_pos.y < 0 or world_pos.y >= grid_size.y:
			return false
	return true

# Check if shape collides with occupied cells in grid
func check_collision(cells: Array, grid_pos: Vector2i, occupied_cells: Array) -> bool:
	for cell in cells:
		var world_pos = grid_pos + cell
		if world_pos in occupied_cells:
			return true
	return false
