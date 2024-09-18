extends CanvasLayer
onready var button_sfx = $"../../SFX_buttons"
var bus_index = AudioServer.get_bus_index("SFX")

func _ready():

	var error_code = $Panel/VBoxContainer/Quitter.connect("pressed", self, "_on_Exit_pressed")
	if error_code != 0:
		print("ERROR: ", error_code)
	visible = false
	

func _on_Exit_pressed():

	AudioServer.set_bus_volume_db(bus_index, 0)  # Restore the original volume
	button_sfx.play()
	var error_code = get_tree().change_scene("res://Scenes/Levels/Level.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)
