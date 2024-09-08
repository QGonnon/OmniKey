extends CanvasLayer

func _ready():

	$Panel/VBoxContainer/Quitter.connect("pressed", self, "_on_Button_pressed", [1])
	visible = false
	

func _on_Button_pressed(value):
	get_tree().change_scene("res://Scenes/Levels/Level.tscn")
