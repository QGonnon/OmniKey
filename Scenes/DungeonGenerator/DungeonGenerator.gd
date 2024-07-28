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
var exit_teleporters = []
var last_scene = -1
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
#			entry_teleporter.position.x += current_x
			entry_teleporters.append(entry_teleporter)
#			print("EntryTeleporter ajouté à la position: ", entry_teleporter.position)
		
		if exit_teleporter:
			# Mettre à jour la position du ExitTeleporter
#			exit_teleporter.position.x += current_x
			exit_teleporters.append(exit_teleporter)
			
#			print("ExitTeleporter ajouté à la position: ", exit_teleporter.position)
#
			exit_teleporter.connect("teleport", self, "_on_exit_teleporter_teleport", [i+1])
#					print("ExitTeleporter connecté à la salle suivante avec index: ", i)
		
		if i == 0 and entry_teleporter:
			# Déplacer le personnage à la position de l'entry_teleporter dans la première salle
			character.position = entry_teleporter.position
			print("Personnage déplacé à la position de l'entry teleporter: ", entry_teleporter.position)
		
		current_x += spacing_x
		
	print("Génération terminée")



func _place_scene(position: Vector2) -> Node2D:
	var num = last_scene
	while num == last_scene:
		num = randi() % scenes.size()
	var random_scene = scenes[num]
	var instance = random_scene.instance()
	instance.position = position
	add_child(instance)
	print("Scène placée à: ", position)
	return instance

func _on_exit_teleporter_teleport(body: Node, next_room_index: int) -> void:
	print("Signal de téléportation reçu pour la salle index: ", next_room_index)
	if next_room_index < entry_teleporters.size():
		var next_entry_teleporter = entry_teleporters[next_room_index]
		if next_entry_teleporter:
			character.global_position = next_entry_teleporter.global_position
			print("Personnage téléporté à la position de l'entry teleporter: ", next_entry_teleporter.position)
		else:
			print("Erreur : EntryTeleporter introuvable pour la salle index: ", next_room_index)
	else:
		
		print("Erreur : index de salle suivant hors limites / dernière salle atteinte")
	

