extends CanvasLayer
onready var button_sfx = $"../../SFX_buttons"

func _ready():
	
	var error_code = $Panel/VBoxContainer/Button1.connect("pressed", self, "_on_Button_pressed", [1])
	if error_code != 0:
		print("ERROR: ", error_code)
	
	error_code = $Panel/VBoxContainer/Button2.connect("pressed", self, "_on_Button_pressed", [2])
	if error_code != 0:
		print("ERROR: ", error_code)
	
	error_code = $Panel/VBoxContainer/Button3.connect("pressed", self, "_on_Button_pressed", [3])
	if error_code != 0:
		print("ERROR: ", error_code)
	
	error_code = $Panel/VBoxContainer/Button4.connect("pressed", self, "_on_Button_pressed", [4])
	if error_code != 0:
		print("ERROR: ", error_code)
	
	hide() # Hide the menu initially

func _on_Button_pressed(_value):
	button_sfx.play()
	var error_code = get_tree().change_scene("res://Scenes/DungeonGenerator/DungeonGenerator.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)
