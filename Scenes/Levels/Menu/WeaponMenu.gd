extends CanvasLayer

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

	hide() # Hide the menu initially

func _on_Button_pressed(value):
	print(String(value) + " sélectionné")
