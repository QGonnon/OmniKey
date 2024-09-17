extends Control

onready var button_sfx = $SFX_buttons

#func _on_Volume_pressed():
#	pass # Replace with function body.

func _on_Back_pressed():
	button_sfx.play()
	get_tree().change_scene("res://Scenes/Menu/MainMenu.tscn")
