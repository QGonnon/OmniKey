extends Area2D

onready var joystick_base = $Base
onready var joystick_petit = $Base/Petit

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false
var touch_index = -1

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			var distance = event.position.distance_to(joystick_base.global_position)
			if distance < max_distance:
				touched = true
				touch_index = event.index
		else:
			if event.index == touch_index:
				touched = false
				touch_index = -1
				joystick_petit.position = Vector2(0, 0)

	if event is InputEventScreenDrag and touched and event.index == touch_index:
		var distance = event.position.distance_to(joystick_base.global_position)
		if distance < max_distance:
			joystick_petit.global_position = event.position
		else:
			var direction = (event.position - joystick_base.global_position).normalized()
			joystick_petit.global_position = joystick_base.global_position + direction * max_distance

func _process(delta):
	if touched:
		var distance = get_global_mouse_position().distance_to(joystick_base.global_position)
		if distance < max_distance:
			joystick_petit.global_position = get_global_mouse_position()
		else:
			var direction = (get_global_mouse_position() - joystick_base.global_position).normalized()
			joystick_petit.global_position = joystick_base.global_position + direction * max_distance

func get_velo():
	var joy_velo = Vector2(0, 0)
	joy_velo.x = joystick_petit.position.x / max_distance
	joy_velo.y = joystick_petit.position.y / max_distance
	return joy_velo
