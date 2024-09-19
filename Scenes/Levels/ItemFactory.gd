extends Node2D
class_name ItemFactory

var item_scene = preload("res://Scenes/InteractiveObjects/Item/Item.tscn")

func _ready() -> void:
	var __ = EVENTS.connect("spawn_special_item", self, "_on_EVENTS_spawn_special_item")
	__ = EVENTS.connect("spawn_item", self, "_on_EVENTS_spawn_item")
	__ = EVENTS.connect("jar_destroyed", self, "_on_EVENTS_jar_destroyed")  # Écoute pour les jars cassés

func _spawn_item(item_data: ItemData, pos: Vector2) -> void:
	var item = item_scene.instance()
	owner.call_deferred("add_child", item)
	item.set_item_data(item_data)
	item.set_global_position(pos)

func _spawn_special_item(special_item_scene: PackedScene, pos: Vector2) -> void:
	var item = special_item_scene.instance()
	owner.call_deferred("add_child", item)
	item.set_global_position(pos)

# Fonction déclenchée lorsqu'un jar est détruit
func _on_EVENTS_jar_destroyed(pos: Vector2) -> void:
	var coin_count = randi() % 10 + 1  # Nombre aléatoire de pièces entre 1 et 10
	for i in range(coin_count):
		var offset = Vector2(randf() * 20 - 10, randf() * 20 - 10)  # Légers décalages aléatoires pour le drop
		_spawn_item(ItemData.new_coin(), pos + offset)  # Génère une pièce avec des données

# Gestion de l'apparition d'objets spéciaux
func _on_EVENTS_spawn_special_item(special_item_scene: PackedScene, pos: Vector2) -> void:
	_spawn_special_item(special_item_scene, pos)

# Gestion de l'apparition d'objets normaux
func _on_EVENTS_spawn_item(item_data: ItemData, pos: Vector2) -> void:
	_spawn_item(item_data, pos)
