extends Node2D
class_name Pathfinding
var tilemap: TileMap

func set_tilemap(_tilemap: TileMap):
	tilemap = _tilemap

func walkable_neighbors(pos: Vector2):
	var cellSize = tilemap.cell_size.x
	var directions = [Vector2.LEFT, Vector2.DOWN, Vector2.UP, Vector2.RIGHT]
	var neighborCoordinates = []
	for c in directions:
		var v = pos + c
		var cell = tilemap.get_cellv(v)
		if cell != 1:
			neighborCoordinates.append(v)
			
	return neighborCoordinates

# Pathfinding logic
func bfs(initial, final) -> Array:
	var visited = []
	var nodes = {initial: null}
	var queue = [initial]
	while not queue.empty():
		var node = queue.front()
		queue.erase(node)
		visited.append(node)
		if node == final:
			break
		var children = walkable_neighbors(node)
		for child in children:
			if child in visited or child in queue:
				continue
			nodes[child] = node
			queue.append(child)
			
	var node = final
	var route: Array = [node]
	while node != null:
		var parent = nodes[node]
		if parent != null:
			route.push_front(parent)
		node = parent
	return route
