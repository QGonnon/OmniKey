extends Node2D
class_name DungeonGenerator

const MIN_DUNGEON_DEPTH = 10

var scenes = [
	preload("res://Scenes/Pieces/Salles/salle0.tscn"),
	preload("res://Scenes/Pieces/Salles/salle1.tscn"),
	preload("res://Scenes/Pieces/Salles/salle2.tscn"),
	preload("res://Scenes/Pieces/Salles/salle3.tscn"),
	preload("res://Scenes/Pieces/Salles/salle4.tscn")
]

export var spacing_x := 1000
var current_x := 0

# Référence au node du personnage
var character

# Pour stocker les références aux EntryTeleporters
var entry_teleporters = []

#### FONCTIONS INTÉGRÉES ####

func _ready() -> void:
	print("Génération du donjon...")
	character = get_node("Character")
	_generate_dungeon()
	print("Donjon généré. Prêt.")

#### LOGIQUE ####

func _generate_dungeon() -> void:
	print("Début de la génération")

	for i in range(MIN_DUNGEON_DEPTH):
		var instance = _place_scene(Vector2(current_x, 0))
		
		# Assurez-vous que les noms des téléporteurs sont corrects
		var entry_teleporter = instance.get_node("EntryTeleporter")
		var exit_teleporter = instance.get_node("ExitTeleporter")
		
		if entry_teleporter:
			# Mettre à jour la position du EntryTeleporter
			entry_teleporter.position.x += current_x
			entry_teleporters.append(entry_teleporter)
			print("EntryTeleporter ajouté à la position: ", entry_teleporter.position)
		
		if exit_teleporter:
			# Mettre à jour la position du ExitTeleporter
			exit_teleporter.position.x += current_x
			if i > 0:
				var prev_instance = get_child(get_child_count() - 2)
				var prev_exit_teleporter = prev_instance.get_node("ExitTeleporter")
				if prev_exit_teleporter:
					prev_exit_teleporter.connect("teleport", self, "_on_exit_teleporter_teleport", [i])
					print("ExitTeleporter connecté à la salle suivante avec index: ", i)
		
		if i == 0 and entry_teleporter:
			# Déplacer le personnage à la position de l'entry_teleporter dans la première salle
			character.position = entry_teleporter.position
			print("Personnage déplacé à la position de l'entry teleporter: ", entry_teleporter.position)
		
		current_x += spacing_x
		
	print("Génération terminée")

func _place_scene(position: Vector2) -> Node2D:
	var random_scene = scenes[randi() % scenes.size()]
	var instance = random_scene.instance()
	instance.position = position
	add_child(instance)
	print("Scène placée à: ", position)
	return instance

func _on_exit_teleporter_teleport(body: Node, next_room_index: int) -> void:
	if body == character:
		if next_room_index < entry_teleporters.size():
			var next_entry_teleporter = entry_teleporters[next_room_index]
			if next_entry_teleporter:
				character.position = next_entry_teleporter.position
				print("Personnage téléporté à la position de l'entry teleporter: ", next_entry_teleporter.position)

#### ENTRÉES ####

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_generate_dungeon()
