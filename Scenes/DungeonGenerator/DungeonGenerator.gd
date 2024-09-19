extends Node2D
class_name DungeonGenerator

const MIN_DUNGEON_DEPTH = 3
onready var start_coin = GAME.get_nb_coins()

var scenes = [
	preload("res://Scenes/Pieces/Salles/salle0.tscn"),
	preload("res://Scenes/Pieces/Salles/salle1.tscn"),
	preload("res://Scenes/Pieces/Salles/salle2.tscn"),
	preload("res://Scenes/Pieces/Salles/salle3.tscn"),
	preload("res://Scenes/Pieces/Salles/salle4.tscn"),
	preload("res://Scenes/Pieces/Salles/salle5.tscn"),
	preload("res://Scenes/Pieces/Salles/salle6.tscn")
]

var jar = preload("res://Scenes/InteractiveObjects/Jar/Jar.tscn")
var chest = preload("res://Scenes/InteractiveObjects/Chest/Chest.tscn")
var items = [jar, chest]

var nbKill = 0

onready var endMenu = $EndMissons/CanvasLayer
onready var loseMenu = $LosingMenu/CanvasLayer
onready var losing_SFX = $losingSFX
onready var winning_SFX = $winningSFX
var bus_index = AudioServer.get_bus_index("SFX")

var ennemy1 = preload("res://Scenes/Actors/Enemy/Skeleton/Skeleton.tscn")
var ennemy2 = preload("res://Scenes/Actors/Enemy/Skeleton/Skeleton2.tscn")
var ennemies = [ennemy1, ennemy2]

export var spacing_x := 1000
var current_x := 0

# Référence au node du personnage
var character
var arrow_sprite: Sprite

# Pour stocker les références aux EntryTeleporters et ExitTeleporters
var entry_teleporters = []
var exit_teleporters = []
var last_scene = 0
var enemies = []
var current_room_index = 0  # Index de la salle actuelle où se trouve le joueur

#### FONCTIONS INTÉGRÉES ####

func _ready() -> void:
	print("Génération du donjon...")
	character = get_node("Character")
	arrow_sprite = Sprite.new()
	arrow_sprite.texture = preload("res://Scenes/DungeonGenerator/fleche-droite.png")
	arrow_sprite.position = Vector2(0, -50)  # Positionnez la flèche au-dessus du personnage
	arrow_sprite.scale = Vector2(0.1, 0.1)
	arrow_sprite.visible = false  # La flèche est cachée par défaut
	character.add_child(arrow_sprite)
	_generate_dungeon()
	print("Donjon généré. Prêt.")

#### LOGIQUE ####

func _process(_delta: float) -> void:
	if arrow_sprite.visible and current_room_index < exit_teleporters.size():
		var exit_teleporter = exit_teleporters[current_room_index]
		if exit_teleporter:
			var direction = (exit_teleporter.global_position - character.global_position).normalized()
			arrow_sprite.rotation = direction.angle()

func _generate_dungeon() -> void:
	print("Début de la génération")

	for i in range(MIN_DUNGEON_DEPTH):
		var instance = _place_scene(Vector2(current_x, 0))
		
		# Assurez-vous que les noms des téléporteurs sont corrects
		var entry_teleporter = instance.get_node("EntryTeleporter")
		var exit_teleporter = instance.get_node("ExitTeleporter")
		var enemies_in_room = instance.get_tree().get_nodes_in_group("Enemy")
		
		enemies.append(enemies_in_room)  # Stocker les ennemis de la salle actuelle
		
		for enemy in enemies_in_room:
			if not enemy.is_connected("died", self, "_on_enemy_died"):
				enemy.connect("died", self, "_on_enemy_died", [i, enemy])
		
		if entry_teleporter:
			entry_teleporters.append(entry_teleporter)
		
		if exit_teleporter:
			exit_teleporters.append(exit_teleporter)
			exit_teleporter.connect("teleport", self, "_on_exit_teleporter_teleport", [i+1])
		
		if i == 0 and entry_teleporter:
			# Déplacer le personnage à la position de l'entry_teleporter dans la première salle
			character.position = entry_teleporter.position
			current_room_index = 0  # Définir la première salle comme salle actuelle
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
	var spawnPoints = instance.get_node("SpawnPoints")
	var spawnEnnemyPoints = instance.get_node("SpawnEnnemy")
	if spawnPoints != null:
		placeItems(instance, spawnPoints.get_children())
	if spawnEnnemyPoints != null:
		placeEnnemy(instance, spawnEnnemyPoints.get_children())
	
	print("Scene placed at: ", position)
	return instance
	
func placeEnnemy(salle, spawn_points):
	for spawn_point in spawn_points:
		if spawn_point:
			var ennemy_scene = ennemies[randi() % ennemies.size()]
			var ennemy_instance = ennemy_scene.instance()
			ennemy_instance.position = salle.position + spawn_point.position
			add_child(ennemy_instance)
		else:
			print("Spawn point is null.")

func placeItems(salle, spawn_points):
	for spawn_point in spawn_points:
		if spawn_point:
			var item_scene = items[randi() % items.size()]
			var item_instance = item_scene.instance()
			item_instance.position = salle.position + spawn_point.position
			add_child(item_instance)  # Ajouter l'objet comme enfant du point de spawn
			print("Adding item at position: ", item_instance.global_position)
		else:
			print("Spawn point is null.")

func _on_exit_teleporter_teleport(_body: Node, next_room_index: int) -> void:
	current_room_index = next_room_index  # Mise à jour de l'index de la salle actuelle
	_cleanup_deleted_objects(next_room_index-1)
	
	if _on_enemy_exited(next_room_index-1):
		arrow_sprite.visible = false  # Cache la flèche lorsqu'on change de pièce
		if next_room_index < entry_teleporters.size():
			var next_entry_teleporter = entry_teleporters[next_room_index]
			if next_entry_teleporter:
				character.global_position = next_entry_teleporter.global_position
				print("Personnage téléporté à la position de l'entry teleporter: ", next_entry_teleporter.position)
			else:
				print("Erreur : EntryTeleporter introuvable pour la salle index: ", next_room_index)
		else:
			winning_SFX.play()
			var texte = "Pièces obtenues : " + str(GAME.get_nb_coins()-start_coin)
			$EndMissons/CanvasLayer/Panel/VBoxContainer/Pieces.text = texte
			endMenu.visible = true
func _cleanup_deleted_objects(room_index: int) -> void:
	if room_index < enemies.size():
		for i in range(enemies[room_index].size() - 1, -1, -1):
			if not is_instance_valid(enemies[room_index][i]):
				enemies[room_index].remove(i)
		print("Objets supprimés nettoyés pour la salle index: ", room_index)

func _on_enemy_died(room_index: int, enemy: Node) -> void:
	enemies[room_index].erase(enemy)
	print("Ennemi supprimé de la salle index: ", room_index)
	
	# Vérifiez si tous les ennemis de la salle sont morts
	if enemies[room_index].size() == 0:
		print("Tous les ennemis de la salle index ", room_index, " sont morts.")
		# Montre la flèche si c'est la salle actuelle
		if room_index == current_room_index:
			arrow_sprite.visible = true  
		else:
			# Si le joueur est encore dans une ancienne salle, mettez à jour la flèche
			if current_room_index < exit_teleporters.size():
				arrow_sprite.visible = true

func _on_enemy_exited(room_index: int) -> bool:
	if room_index < enemies.size() and enemies[room_index].size() == 0:
		return true
	else:
		return false

func _on_Character_hp_changed(hp):
	if hp==0:
		AudioServer.set_bus_volume_db(bus_index, -80)  # -80 dB effectively mutes the bus
		losing_SFX.play()
		loseMenu.visible = true
		GAME.set_nb_coins(start_coin)
		get_tree().paused = true
