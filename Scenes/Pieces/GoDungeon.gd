extends Area2D

signal createDungeon

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Character":
		print("character touched dungeon")
#		emit_signal("createDungeon")
