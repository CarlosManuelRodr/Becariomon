extends Node2D
class_name Pathfinding
var tilemap: TileMap

class AStarNode:
	var parent
	var pos
	var g
	var f
	var h
	
	static func squared_distance(p1, p2):
		return pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2)
	
	func _init(parent, pos, final):
		self.pos = pos
		self.parent = parent
		self.h = squared_distance(pos, final)
		if parent == null:
			self.g = 0
			self.f = h
		else:
			self.g = self.parent.g + 1
			self.f = self.h + self.g

func set_tilemap(_tilemap: TileMap):
	tilemap = _tilemap

func walkable_neighbors(pos: Vector2) -> Array:
	var directions = [Vector2.LEFT, Vector2.DOWN, Vector2.UP, Vector2.RIGHT]
	var neighborCoordinates = []
	for c in directions:
		var v = pos + c
		var cell = tilemap.get_cellv(v)
		if cell != 1:
			neighborCoordinates.append(v)
			
	return neighborCoordinates

func create_route(final: Vector2, exploredNodes: Dictionary):
	var node = final
	var route = [node]
	while node != null:
		var parent = exploredNodes[node]
		if parent != null:
			route.push_front(parent)
		node = parent
	return route
	
func create_route2(n: AStarNode):
	var route = []
	while n != null:
		route.push_front(n.pos)
		n = n.parent
	return route

# Pathfinding logic
func bfs(initial: Vector2, final: Vector2) -> Array:
	var visited = []
	var exploredNodes = {initial: null}
	var queue = [initial]
	while not queue.empty():
		var node = queue.front()
		queue.erase(node)
		visited.append(node)
		if node == final:
			break
		for child in walkable_neighbors(node):
			if child in visited or child in queue:
				continue
			exploredNodes[child] = node
			queue.append(child)
			
	return create_route(final, exploredNodes)
	
func dfs(initial: Vector2, final: Vector2) -> Array:
	var visited = []
	var stack = [initial]
	var exploredNodes = {initial: null}
	var node: Vector2
	while not stack.empty():
		node = stack.pop_back()
		visited.append(node)
		if node == final:
			break
		for child in walkable_neighbors(node):
			if not child in visited:
				visited.append(child)
				stack.append(child)
				exploredNodes[child] = node
				
	return create_route(node, exploredNodes)

func astar(initial: Vector2, final: Vector2):
	var openSet = {initial: AStarNode.new(null, initial, final)}
	var visited = []
	var bestNode: AStarNode = null
	while not openSet.empty():
		var bestF = INF
		for n in openSet:
			var node: AStarNode = openSet[n]
			if node.f < bestF:
				bestF = node.f
				bestNode = node
				
		if bestNode == null:
			break
		if bestNode.pos == final:
			break
		visited.append(bestNode.pos)
		for child in walkable_neighbors(bestNode.pos):
			var node = AStarNode.new(bestNode, child, final)
			if child in visited:
				continue
			if openSet.has(child):
				if openSet[child].g <= node.g:
					continue
			openSet[child] = node
		openSet.erase(bestNode.pos)
		
	return create_route2(bestNode)
