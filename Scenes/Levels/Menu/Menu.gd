extends Node2D

func _ready():
	$Area.connect("body_entered", self, "_on_body_entered")
	$Area.connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body):
	if body.name == "Character":
		$CanvasLayer.show()

func _on_body_exited(body):
	if body.name == "Character":
		$CanvasLayer.hide()
