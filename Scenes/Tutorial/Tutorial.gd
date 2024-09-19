extends Node2D

onready var ennemies = get_tree().get_nodes_in_group("Enemy")
onready var entry_teleporter = $EntryTeleporter
onready var exit_teleporter = $ExitTeleporter
onready var endMenu = $EndMissons/CanvasLayer

func _ready():
	var character = get_node("Character")
	print(ennemies.size())
	character.position = entry_teleporter.position
	var exit_teleporterShape = get_node("ExitTeleporter/CollisionShape2D")
	# Connect exit teleporter's teleport signal
	if exit_teleporter:
		exit_teleporter.connect("teleport", self, "_exitTeleporter")
		
	if exit_teleporterShape.shape is CircleShape2D:
			var circle_shape = exit_teleporterShape.shape as CircleShape2D
			var radius = circle_shape.radius
			
			var line2d = Line2D.new()
			line2d.width = 2
			line2d.default_color = Color(1, 0, 0)  # Rouge

			var num_points = 350  # Plus de points pour plus de précision
			for t in range(num_points):
				var angle = 2 * PI * t / num_points
				var point = Vector2(cos(angle), sin(angle)) * radius
				line2d.add_point(exit_teleporterShape.global_position + point)  # Ajouter global_position

			add_child(line2d)
	
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
	print("on entre dans la func de teleportation")
	if ennemies.size() == 0:
		$EndMissons/CanvasLayer.visible = true
	else:
		print("Cannot teleport, enemies still remain.")
