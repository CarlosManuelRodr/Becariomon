extends KinematicBody2D

export var blockCell: int
var stepSize: int
var tilemap: TileMap
var pathfinding: Pathfinding
var isMoving: bool

func _ready():
	isMoving = false
	tilemap = get_parent().get_node("TileMap")
	pathfinding = get_parent().get_node("Pathfinding")
	
	# Error checking
	if tilemap == null:
		push_error("Tilemap couldn't be loaded")
	if pathfinding == null:
		push_error("Pathfinding couldn't be loaded")
		
	pathfinding.set_tilemap(tilemap)
	stepSize = tilemap.cell_size.x

func is_path_clear(newWorldPosition: Vector2) -> bool:
	var tileID = tilemap.get_cellv(newWorldPosition / stepSize)
	return tileID != blockCell
	
func walk_route(origin, destination):
	isMoving = true
	var route = pathfinding.bfs(origin, destination)
	route.pop_front()
	for cellPosition in route:
		position = tilemap.map_to_world(cellPosition)
		$Sfx.play()
		yield(get_tree().create_timer(0.5), "timeout")
	isMoving = false
	
func handle_directional_input(event):
	var moveDirection = Vector2.ZERO
	if event.is_action_pressed("ui_left"):
		moveDirection = Vector2(-1, 0)
	elif event.is_action_pressed("ui_up"):
		moveDirection = Vector2(0, -1)
	elif event.is_action_pressed("ui_right"):
		moveDirection = Vector2(1, 0)
	elif event.is_action_pressed("ui_down"):
		moveDirection = Vector2(0, 1)
		
	if moveDirection != Vector2.ZERO:
		var newPosition = position + stepSize * moveDirection
		if is_path_clear(newPosition):
			position = newPosition
			$Sfx.play()

func handle_mouse_input(event):
	var eventIsMouseButton = event is InputEventMouseButton and event.is_pressed()
	if eventIsMouseButton:
		var buttonIsLeftClick = event.button_index == BUTTON_LEFT
		if buttonIsLeftClick:
			var coords = tilemap.world_to_map(get_global_mouse_position())
			if tilemap.get_cellv(coords) != blockCell:
				var origin = tilemap.world_to_map(position)
				var destination = coords
				walk_route(origin, destination)

func _input(event):
	if not isMoving:
		handle_directional_input(event)
		handle_mouse_input(event)
