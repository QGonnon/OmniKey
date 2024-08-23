extends Actor
class_name Enemy

onready var behaviour_tree = $BehaviourTree
onready var chase_area = $ChaseArea
onready var attack_area = $AttackArea
onready var path_line = $PathLine
onready var bullet = preload("res://Scenes/Actors/Shoot/projectile.tscn")

var target : Node2D = null
var path : Array = []

var pathfinder : Pathfinder = null

var target_in_chase_area : bool = false setget set_target_in_chase_area
var target_in_attack_area : bool = false setget set_target_in_attack_area

var delay = 0.75
var countTime = 0

signal target_in_chase_area_changed
signal target_in_attack_area_changed
signal move_path_finished
signal died

#### ACCESSORS ####

func set_target_in_chase_area(value: bool) -> void:
	if value != target_in_chase_area:
		target_in_chase_area = value
		emit_signal("target_in_chase_area_changed", target_in_chase_area)

func set_target_in_attack_area(value: bool) -> void:
	if value != target_in_attack_area:
		target_in_attack_area = value
		emit_signal("target_in_attack_area_changed", target_in_attack_area)


#### BUILT-IN ####

func _ready() -> void:
	var __ = chase_area.connect("body_entered", self, "_on_ChaseArea_body_entered")
	__ = chase_area.connect("body_exited", self, "_on_ChaseArea_body_exited")
	__ = attack_area.connect("body_entered", self, "_on_AttackArea_body_entered")
	__ = attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	__ = $BehaviourTree/Attack/Cooldown.connect("timeout", self, "_on_attack_cooldown_finished")
	__ = connect("target_in_chase_area_changed", self, "_on_target_in_chase_area_changed")
	__ = connect("target_in_attack_area_changed", self, "_on_target_in_attack_area_changed")
	
	path_line.set_as_toplevel(true)

func _process(delta):
	if behaviour_tree.get_state_name() == "Chase":
		shoot(delta)

#### LOGIC ####

func shoot(delta):
	countTime += delta
	if countTime > delay:
		var projectile_instance = bullet.instance()
		projectile_instance.collision_layer = 1
		projectile_instance.collision_mask = 2
		projectile_instance.speed = 500
		
		projectile_instance.global_position = position
		projectile_instance.rotation = projectile_instance.get_angle_to(target.position)
		projectile_instance.scale *= 0.75
		
		# Vérification si owner est null
		if owner:
			owner.add_child(projectile_instance)
		else:
			print("Owner is null, using root as fallback.")
			get_tree().root.add_child(projectile_instance)
		countTime = 0

func _update_target() -> void:
	if !target_in_attack_area && !target_in_chase_area:
		target = null

func _update_behaviour_state() -> void:
	if state_machine.get_state_name() == "Dead":
		return
		
	if target_in_chase_area:
		behaviour_tree.set_state("Chase")
		if target_in_attack_area:
			if $BehaviourTree/Attack.is_cooldown_running():
				behaviour_tree.set_state("Inactive")
				path = []
			else:
				behaviour_tree.set_state("Attack")
	else:
		behaviour_tree.set_state("Wander")

func update_move_path(dest: Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)
	
	if path_line.is_visible():
		path_line.set_points(path)

func move_along_path(delta: float) -> void:
	if path.empty():
		return
	
	var dir = global_position.direction_to(path[0])
	var dist = global_position.distance_to(path[0])
	
	set_moving_direction(dir)
	
	if dist <= speed * delta:
		var __ = move_and_collide(dir * dist)
		path.remove(0)
		
		if path.empty():
			emit_signal("move_path_finished")
	else:
		var __ = move_and_collide(dir * speed * delta)

func can_attack() -> bool:
	return !$BehaviourTree/Attack.is_cooldown_running() && target_in_attack_area

func die() -> void:
	.die()
	behaviour_tree.set_state("Inactive")
	emit_signal("died")

# Méthode hurt pour infliger des dégâts
func hurt(damage: int) -> void:
	set_hp(hp - damage)
	if hp <= 0:
		die()

#### SIGNAL RESPONSES ####

func _on_ChaseArea_body_entered(body: Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(true)
		target = body

func _on_ChaseArea_body_exited(body: Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(false)

func _on_AttackArea_body_entered(body: Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(true)
		target = body

func _on_AttackArea_body_exited(body: Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(false)

func _on_target_in_chase_area_changed(_value: bool) -> void:
	_update_target()
	_update_behaviour_state()

func _on_target_in_attack_area_changed(_value: bool) -> void:
	_update_target()
	if target_in_attack_area:
		_update_behaviour_state()

func _on_moving_direction_changed() -> void:
	face_direction(moving_direction)

func _on_StateMachine_state_changed(state: State) -> void:
	if state_machine == null:
		return
	
	if state_machine.previous_state == $StateMachine/Attack or state_machine.previous_state == $StateMachine/Hurt:
		_update_behaviour_state()
	
	if state.name == "Attack":
		face_position(target.global_position)

func _on_attack_cooldown_finished() -> void:
	_update_behaviour_state()
