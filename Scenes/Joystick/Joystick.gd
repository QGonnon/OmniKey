extends Area2D

onready var joystick_base = $Base
onready var joystick_petit = $Base/Petit

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

func _input(event):
	if event is InputEventScreenDrag:
		var distance = event.position.distance_to(joystick_base.global_position)
		if not touched:
			if distance<max_distance:
				touched = true
			else:
				joystick_petit.position = Vector2(0,0)
				touched = false
				
func _process(delta):
	if touched:
		joystick_petit.global_position = get_global_mouse_position()
		joystick_petit.position = joystick_base.position + (joystick_petit.position - joystick_base.position).clamped(max_distance)
		
		
func get_velo():
	var joy_velo = Vector2(0,0)
	joy_velo.x = joystick_petit.position.x / max_distance
	joy_velo.y = joystick_petit.position.y / max_distance
	return joy_velo
