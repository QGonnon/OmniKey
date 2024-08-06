extends CanvasLayer

func _ready():
	
	$Panel/VBoxContainer/Button1.connect("pressed", self, "_on_Button_pressed", [1])
	$Panel/VBoxContainer/Button2.connect("pressed", self, "_on_Button_pressed", [2])
	$Panel/VBoxContainer/Button3.connect("pressed", self, "_on_Button_pressed", [3])
	hide() # Hide the menu initially

func _on_Button_pressed(value):
	print(String(value) + " sélectionné")
