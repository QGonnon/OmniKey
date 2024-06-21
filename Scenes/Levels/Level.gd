extends YSort

onready var pathfinder = $Tilemap/Pathfinder
export var move_speed = 250
onready var character = $Character
onready var attackJoystick = $UI_Container/UI/HUD/AttackJoystick
onready var moveJoystick = $UI_Container/UI/HUD/Joystick
var velocity = Vector2(0,0)
var attackVelocity = Vector2(0,0)
onready var skin = character.get_node("gun")

func _process(delta):
	velocity = moveJoystick.get_velo()
	var joyAngle = rad2deg(velocity.angle())
	
	
	skin.rotation=attackJoystick.get_velo().angle()
	
	var rotaGun = int(skin.rotation_degrees) % 360
	rotaGun = 360+rotaGun if rotaGun < 0 else rotaGun
	if 90 < rotaGun and rotaGun < 270:
		skin.scale.y = -1
		
	else :
		skin.scale.y = 1
	if attackJoystick.touched:
		character.shoot(delta)
	else :
		skin.play("Idle")  # Revenir à l'animation "Idle" ou une autre animation par défaut
		
	
	var up = int(-135 < joyAngle and joyAngle < -45)
	var down = int(45 < joyAngle and joyAngle < 135)
	var right = int(-45 < joyAngle and joyAngle < 45)
	var left = int(135 < joyAngle or joyAngle < -135)
	var dir = Vector2(
		right - left,
		down - up
	)
	

	character.move_and_slide(velocity*move_speed, Vector2.UP)
	if moveJoystick.touched:
		character.state_machine.set_state("Move")
	else:
		character.state_machine.set_state("Idle")
	character.set_facing_direction(dir.normalized())
	pass

func _ready() -> void:
	var __ = EVENTS.connect("actor_died", self, "_on_EVENTS_actor_died")
	
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies_array:
		enemy.pathfinder = pathfinder


func _on_EVENTS_actor_died(actor: Actor) -> void:
	if actor is Enemy:
		var enemies_array = get_tree().get_nodes_in_group("Enemy")
		
		if enemies_array == [actor]:
			EVENTS.emit_signal("room_finished")
