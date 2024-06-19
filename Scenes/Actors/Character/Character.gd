extends Actor
class_name Character

#### SHOOTING ####

onready var bullet = preload("res://Scenes/Actors/Shoot/projectile.tscn")
onready var shootingPoint = $gun/ShootingPoint
onready var skin = $gun


var delay = 0.25
var countTime = 0

func look_in_direction(direction):
	var angle = direction.angle()
	skin.rotation = angle

	if direction.x > 0:
		skin.scale.x = 1
	elif direction.x < 0:
		skin.scale.x = -1

func shoot():
	var projectile_instance = bullet.instance()
	state_machine.set_state("shooting")
	skin.play("shooting")  # Jouer l'animation "shooting"
	projectile_instance.global_position = position
	var targets = get_tree().get_nodes_in_group("Enemy")
	if targets.size() != 0:
		var target = getNearest(targets)
		projectile_instance.look_at(target.global_position)
		skin.look_at(target.global_position)
	projectile_instance.global_position = shootingPoint.global_position
	owner.add_child(projectile_instance)
	
func getNearest(group:Array):
	var dist = INF
	var nearest = null
	for node in group:
		var nodeDist = position.distance_to(node.position)
		if nodeDist < dist:
			dist = nodeDist
			nearest = node
	return nearest

func _process(delta):
	var targets = get_tree().get_nodes_in_group("Enemy")
	if targets.size() != 0:
		var target = getNearest(targets)
		skin.look_at(target.global_position)
		var rotaGun = int(skin.rotation_degrees) % 360
		rotaGun = 360+rotaGun if rotaGun < 0 else rotaGun
		if 90 <	rotaGun and rotaGun < 270:
			skin.flip_v = true
		else :
			skin.flip_v = false
	if Input.is_action_pressed("shooting"):
		state_machine.set_state("shooting")
		countTime += delta
		if countTime > delay:
			shoot()
			countTime = 0
	else:
		if state_machine.get_state_name() == "shooting":
			state_machine.set_state("Idle")
			skin.play("Idle")  # Revenir à l'animation "Idle" ou une autre animation par défaut

#### BUILT-IN ####

func _input(_event: InputEvent) -> void:
	# Update the direction
	var dir = Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)
	
	set_moving_direction(dir.normalized())
	
	# Update the state based on the input
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.set_state("Attack")
	
	_update_state()

#### LOGIC ####

func _update_state() -> void:
	if not state_machine.get_state_name() in ["Attack", "Parry", "shooting"]:
		if Input.is_action_pressed("block"):
			state_machine.set_state("Block")
		
		elif moving_direction == Vector2.ZERO:
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Move")

func _interaction_attempt() -> bool:
	var bodies_array = attack_hit_box.get_overlapping_bodies()
	var attempt_success = false
	
	for body in bodies_array:
		if body.has_method("interact"):
			body.interact()
			attempt_success = true
	
	return attempt_success

#### SIGNAL RESPONSES ####

func _on_hp_changed(new_hp: int) -> void:
	._on_hp_changed(new_hp)
	
	EVENTS.emit_signal("character_hp_changed", new_hp)

func _on_state_changed(new_state: Object) -> void:
	if new_state.name == "Attack":
		if _interaction_attempt():
			state_machine.set_state("Idle")
	
	elif state_machine.previous_state == $StateMachine/Attack:
		_update_state()
	
	._on_state_changed(new_state)
