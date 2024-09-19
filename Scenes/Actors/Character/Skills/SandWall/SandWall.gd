extends Line2D

func _ready():
	width=4
	
	# Créer la courbe
	var curve_points = PoolVector2Array()
	var numPoints=32
	for i in range(numPoints+1):
		var t = -i/float(numPoints)
		var pi = PI/2*t
		curve_points.append(Vector2(cos(pi),sin(pi))*40)
	
	points = curve_points
	
	for i in points.size()-1:
		var new_shape = CollisionShape2D.new()
		$RigidBody2D.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 10)
		new_shape.shape = rect
	
	var __ = $RigidBody2D.connect("body_entered",self,"_on_BodyEntered")

func _process(_delta):
	rotation+=30*_delta

func _on_BodyEntered(body):
	if body.has_method("hurt") and body.state_machine.get_state_name()!='Dead':
		body.hurt(0.5)
