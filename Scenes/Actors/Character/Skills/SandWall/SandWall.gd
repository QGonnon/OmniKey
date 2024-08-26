extends Line2D

onready var character = $"%Character"

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
		$StaticBody2D.add_child(new_shape)
		var segment = SegmentShape2D.new()
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 10)
		new_shape.shape = rect
	
	# Créer et configurer la Timer
	var timer = Timer.new()
	timer.wait_time = 50  # Temps d'attente en secondes avant de faire disparaître le mur
	timer.one_shot = true  # Assurez-vous que la Timer ne se déclenche qu'une seule fois
	add_child(timer)  # Ajouter la Timer comme enfant du mur de sable

	# Connecter le signal 'timeout' de la Timer à la fonction _on_Timer_timeout
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	# Démarrer la Timer
	timer.start()

func _process(delta):
	rotation+=0.5
	pass

# Cette fonction sera appelée lorsque le signal 'timeout' de la Timer est émis
func _on_Timer_timeout():
	queue_free()
