extends Area2D

signal teleport


func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Character":
		emit_signal("teleport", body)
