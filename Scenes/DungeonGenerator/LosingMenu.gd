extends CanvasLayer
onready var button_sfx = $"../../SFX_buttons"
func _ready():

	var error_code = $Panel/VBoxContainer/Quitter.connect("pressed", self, "_on_Exit_pressed")
	if error_code != 0:
		print("ERROR: ", error_code)
	visible = false
	

func _on_Exit_pressed():
	button_sfx.play()
	get_tree().paused=false
	var error_code = get_tree().change_scene("res://Scenes/Levels/Level.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)
