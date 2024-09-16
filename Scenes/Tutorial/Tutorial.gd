extends Node2D

onready var ennemies = get_tree().get_nodes_in_group("Enemy")
onready var entry_teleporter = $EntryTeleporter
onready var exit_teleporter = get_node("ExitTeleporter")
onready var endMenu = $EndMissons/CanvasLayer

func _ready():
	var character = get_node("Character")
	print(ennemies.size())
	character.position = entry_teleporter.position

	# Connect exit teleporter's teleport signal
	if exit_teleporter:
		exit_teleporter.connect("teleport", self, "_exitTeleporter")

	# Connect each enemy's died signal to _on_enemy_died
	for enemy in ennemies:
		if not enemy.is_connected("died", self, "_on_enemy_died"):
			enemy.connect("died", self, "_on_enemy_died", [enemy])

func _on_enemy_died(enemy: Node) -> void:
	# Remove the dead enemy from the list
	ennemies.erase(enemy)
	
	print("Nombre d'ennemies restant : ", ennemies.size())


func _exitTeleporter() -> void:
	# Check if there are no remaining enemies before teleporting
	if ennemies.size() == 0:
		endMenu.visible = true
	else:
		print("Cannot teleport, enemies still remain.")
