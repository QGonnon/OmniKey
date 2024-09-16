extends YSort

onready var pathfinder = $Tilemap/Pathfinder
onready var character = $Character

func _ready() -> void:

	var error_code = EVENTS.connect("actor_died", self, "_on_EVENTS_actor_died")
	if error_code != 0:
		print("ERROR: ", error_code)
	
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies_array:
		enemy.pathfinder = pathfinder

func _on_EVENTS_actor_died(actor: Actor) -> void:
	if actor is Enemy:
		var enemies_array = get_tree().get_nodes_in_group("Enemy")
		
		if enemies_array == [actor]:
			EVENTS.emit_signal("room_finished")
