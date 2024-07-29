extends YSort

onready var pathfinder = $Tilemap/Pathfinder
onready var character = $Character
onready var attackJoystick = character.get_node("UI_Container/UI/HUD/AttackJoystick")
onready var moveJoystick = character.get_node("UI_Container/UI/HUD/Joystick")
onready var spellBtn1 = character.get_node("UI_Container/UI/HUD/SpellBtn1")


var velocity = Vector2(0,0)
var attackVelocity = Vector2(0,0)
onready var skin = character.get_node("gun")

func _ready() -> void:
	var __ = EVENTS.connect("actor_died", self, "_on_EVENTS_actor_died")
	
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies_array:
		enemy.pathfinder = pathfinder
	
	add_child(character.skill1.active_timer)
	add_child(character.skill1.cooldown_timer)
	
func _process(delta):
#	velocity = moveJoystick.get_velo()
#	var joyAngle = rad2deg(velocity.angle())
#
#	skin.rotation = attackJoystick.get_velo().angle()
#
#	var rotaGun = int(skin.rotation_degrees) % 360
#	rotaGun = 360 + rotaGun if rotaGun < 0 else rotaGun
#	var scaleGun = 0.50
#	if 90 < rotaGun and rotaGun < 270:
#		skin.scale.y = -scaleGun
#		skin.scale.x = scaleGun
#	else:
#		skin.scale.y = scaleGun
#		skin.scale.x = scaleGun
#
#	if attackJoystick.touched:
#		character.shoot(delta)
#	else:
#		skin.play("Idle")  # Revenir à l'animation "Idle" ou une autre animation par défaut
	
#	var up = int(-135 < joyAngle and joyAngle < -45)
#	var down = int(45 < joyAngle and joyAngle < 135)
#	var right = int(-45 < joyAngle and joyAngle < 45)
#	var left = int(135 < joyAngle or joyAngle < -135)
#	var dir = Vector2(right - left, down - up)
	
	# Appliquer la vitesse boostée si nécessaire
#	var current_speed = character.move_speed * character.skill1.speedModifier
#	character.move_and_slide(velocity * current_speed, Vector2.UP)
#
#	if moveJoystick.touched:
#		character.state_machine.set_state("Move")
#	else:
#		character.state_machine.set_state("Idle")
#
#	character.set_facing_direction(dir.normalized())
	
	# Activer le skill de boost de vitesse
	if Input.is_action_just_pressed("spellCast1"):
		character.skill1.activate()
		#print(character.skill1.active_timer.time_left)
	
	var skill1 = character.skill1
	if not skill1.active_timer.is_stopped():
		spellBtn1.get_node("ActifProgress").value = skill1.active_timer.time_left/skill1.active_timer_duration*100
		spellBtn1.get_node("Label").text = str(stepify(skill1.active_timer.time_left, 0.1))
	elif not skill1.cooldown_timer.is_stopped():
		spellBtn1.get_node("InactifProgress").value = skill1.cooldown_timer.time_left/skill1.cooldown_timer_duration*100
		spellBtn1.get_node("Label").text = str(stepify(skill1.cooldown_timer.time_left, 0.1))
	else:
		spellBtn1.get_node("Label").text = ""

func _on_EVENTS_actor_died(actor: Actor) -> void:
	if actor is Enemy:
		var enemies_array = get_tree().get_nodes_in_group("Enemy")
		
		if enemies_array == [actor]:
			EVENTS.emit_signal("room_finished")

