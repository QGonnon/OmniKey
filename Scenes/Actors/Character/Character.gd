extends Actor
class_name Character

onready var spellBtn1 = $"../UI_Container/UI/HUD/SpellBtn1"
onready var weapon
var move_speed = 200
var health = 10
var sfx_player: AudioStreamPlayer  # Variable pour l'AudioStreamPlayer
var skill1

func shoot():
	var bullets = weapon.shoot(skill1.attackSpeedModifier)
	for bullet in bullets:
		owner.add_child(bullet)

func getNearest(group:Array):
	var dist = INF
	var nearest = null
	for node in group:
		var nodeDist = position.distance_to(node.position)
		if nodeDist < dist:
			dist = nodeDist
			nearest = node
	return nearest

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
	
func _ready():
	skill1 = Skill.new(PLAYERDATA.getValue("selectedSkill"), self)
	add_child(skill1.active_timer)
	add_child(skill1.cooldown_timer)
	
	var weaponName = PLAYERDATA.getValue("equippedWeapon")
	weaponName = weaponName[0].to_upper() + weaponName.substr(1,-1)
	var weaponScene = "res://Scenes/Actors/Character/Weapons/"+weaponName+"/"+weaponName+".tscn"
	weapon = load(weaponScene).instance()
	add_child(weapon)
	
	var armor = PLAYERDATA.getEquippedArmor()
	max_hp = health * armor.healthModifier
	speed = move_speed * armor.speedModifier

func _process(_delta):
	# Activer le skill
	if Input.is_action_just_pressed("spellCast1"):
		skill1.activate()
		
	# Durée et cooldown du skill
	if not skill1.active_timer.is_stopped():
		spellBtn1.get_node("ActifProgress").value = skill1.active_timer.time_left/skill1.active_timer_duration*100
		spellBtn1.get_node("Label").text = str(stepify(skill1.active_timer.time_left, 0.1))
	elif not skill1.cooldown_timer.is_stopped():
		spellBtn1.get_node("InactifProgress").value = skill1.cooldown_timer.time_left/skill1.cooldown_timer_duration*100
		spellBtn1.get_node("Label").text = str(stepify(skill1.cooldown_timer.time_left, 0.1))
	else:
		spellBtn1.get_node("Label").text = ""
		spellBtn1.get_node("ActifProgress").value = 0
		spellBtn1.get_node("InactifProgress").value = 0
		

#### LOGIC ####

func _update_state() -> void:
	if not state_machine.get_state_name() in ["Attack", "Parry", "shooting", "Death"]:
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
