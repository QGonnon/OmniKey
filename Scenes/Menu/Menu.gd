extends Control

func _on_Play_pressed():
# condition à créé si on à jamais joué :
	get_tree().change_scene("res://Scenes/NarrativePages/NarrativeIntro.tscn")
# sinon :
# 	get_tree().change_scene("res://Scenes/Levels/Level.gd")


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Menu/OptionsMenu.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Menu/CreditsMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
