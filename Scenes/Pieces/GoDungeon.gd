extends Area2D

signal createDungeon

func _ready():
	var error_code = connect("body_entered", self, "_on_body_entered")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_body_entered(body):
	if body.name == "Character":
		print("character touched dungeon")
#		emit_signal("createDungeon")
