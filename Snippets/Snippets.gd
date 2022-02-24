class PathfindingNode:
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

# Utilities
func create_route(n: PathfindingNode):
	var route = []
	while n != null:
		route.push_front(n.pos)
		n = n.parent
	return route
	
