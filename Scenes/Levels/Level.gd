extends YSort

onready var pathfinder = $Tilemap/Pathfinder
export var move_speed = 250
onready var character = $Character
onready var attackJoystick = $UI_Container/UI/HUD/AttackJoystick
var velocity = Vector2(0,0)



func _process(delta):
	velocity = $UI_Container/UI/HUD/Joystick.get_velo()
	
	character.look_in_direction(attackJoystick.get_velo())
	
	character.move_and_slide(velocity*move_speed, Vector2.UP)
	
	
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
