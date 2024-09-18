extends Control

onready var button_sfx = $SFX_buttons

func _on_Play_pressed():
# condition à créé si on à jamais joué :
	button_sfx.play()
	if PLAYERDATA.getValue("skipIntro"):
		var __ = get_tree().change_scene("res://Scenes/Levels/Level.tscn")
	else:	
		var __ = get_tree().change_scene("res://Scenes/NarrativePages/NarrativeIntro.tscn")
# sinon :
# 	get_tree().change_scene("res://Scenes/Levels/Level.tscn")


func _on_Options_pressed():
	button_sfx.play()
	var __ = get_tree().change_scene("res://Scenes/Menu/OptionsMenu.tscn")


func _on_Credits_pressed():
	button_sfx.play()
	var __ = get_tree().change_scene("res://Scenes/Menu/CreditsMenu.tscn")


func _on_Quit_pressed():
	button_sfx.play()
	get_tree().quit()
