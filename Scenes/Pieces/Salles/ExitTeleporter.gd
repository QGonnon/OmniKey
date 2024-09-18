extends Area2D

signal teleport


func _ready():
	var error_code = connect("body_entered", self, "_on_body_entered")
	if error_code != 0:
		print("ERROR: ", error_code)
		
func _on_body_entered(body):
	print(body.name)
	
	if body.name == "Character":
		emit_signal("teleport", body)
