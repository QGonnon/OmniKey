extends TileMap

onready var goDungeon = $GoDungeon

func _ready():
	if goDungeon:
		print("goDungeon node found")
		goDungeon.connect("createDungeon", self, "_on_createDungeon")
		print("Signal connected")
	else:
		print("goDungeon node not found")

func _on_createDungeon():
	print("Signal received: createDungeon")
	var result = get_tree().change_scene("res://Scenes/DungeonGenerator/DungeonGenerator.tscn")
	if result == OK:
		print("Scene change successful")
	else:
		print("Scene change failed with error code: ", result)
