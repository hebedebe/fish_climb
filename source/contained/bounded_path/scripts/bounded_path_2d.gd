class_name BoundedPath2D extends Path2D

func get_rect() -> Rect2:
	var top_left: Vector2 = Vector2.ZERO
	var bottom_right: Vector2 = Vector2.ZERO
	for point: Vector2 in curve.get_baked_points():
		top_left.x = min(top_left.x, point.x)
		top_left.y = min(top_left.y, point.y)
		bottom_right.x = max(bottom_right.x, point.x)
		bottom_right.y = max(bottom_right.y, point.y)
	var rect: Rect2
	rect.position = top_left
	rect.size = bottom_right - top_left
	return rect

func get_average_point_location() -> Vector2:
	var point_total: Vector2 = Vector2.ZERO
	for idx in curve.point_count:
		point_total += curve.sample(idx, 0)
	var point_average: Vector2 = point_total / curve.point_count
	return point_average

func update_node_location() -> void:
	var points_average := get_average_point_location()
	#print(points_average)
	position += points_average
	
	for idx in curve.point_count:
		curve.set_point_position(idx, curve.get_closest_point(curve.sample(idx,0)) - points_average)
