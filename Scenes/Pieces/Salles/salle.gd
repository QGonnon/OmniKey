extends YSort

onready var pathfinder = $Tilemap/Pathfinder
export var move_speed = 250
var velocity = Vector2(0,0)
var attackVelocity = Vector2(0,0)


# Variables pour le skill de boost
var is_boosted = false
var is_on_cooldown = false
var boost_timer = null
var cooldown_timer = null
export var boost_duration = 10 # Durée du boost en secondes
export var cooldown_duration = 5 # Durée du cooldown en secondes

func _ready() -> void:
	var __ = EVENTS.connect("actor_died", self, "_on_EVENTS_actor_died")
	
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies_array:
		enemy.pathfinder = pathfinder
	
	# Créer et ajouter les timers
	boost_timer = Timer.new()
	add_child(boost_timer)
	boost_timer.connect("timeout", self, "_on_boost_timeout")
	
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
	
	# Assigner l'action pour activer le skill
	var input_event = InputEventKey.new()
	input_event.scancode = KEY_S  # Remplacez KEY_S par la touche désirée
	InputMap.add_action("activate_skill")
	InputMap.action_add_event("activate_skill", input_event)

func _process(_delta):
	# Activer le skill de boost de vitesse
	if Input.is_action_just_pressed("spellCast1"):
		activate_skill()

func activate_skill():
	if is_boosted or is_on_cooldown:
		return  # Ne pas réactiver si déjà boosté ou en cooldown

	is_boosted = true
	print("Boost activé")
	boost_timer.start(boost_duration)  # Durée du boost en secondes

func _on_boost_timeout():
	is_boosted = false
	is_on_cooldown = true
	cooldown_timer.start(cooldown_duration)  # Démarrer le cooldown

func _on_cooldown_timeout():
	is_on_cooldown = false

func _on_EVENTS_actor_died(actor: Actor) -> void:
	if actor is Enemy:
		var enemies_array = get_tree().get_nodes_in_group("Enemy")
		
		if enemies_array == [actor]:
			EVENTS.emit_signal("room_finished")
