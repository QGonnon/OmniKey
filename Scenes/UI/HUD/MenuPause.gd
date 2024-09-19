extends CanvasLayer
onready var button_sfx = $"../../../SFX_buttons"
onready var btnResume = $Sprite/Resume
onready var btnQuit = $Sprite/Quitter

onready var credits = preload("res://Scenes/Menu/CreditsMenu.tscn")

func _ready():

#	var error_code = $Panel/Quitter.connect("pressed", self, "_on_Exit_pressed")
#	if error_code != 0:
#		print("ERROR: ", error_code)
	visible = false
	btnResume.connect("pressed", self, "_on_Resume_pressed")
	btnQuit.connect("pressed", self, "_on_Quit_pressed")
	

func _on_Credits_pressed():
#	get_tree().change_scene("res://Scenes/Menu/CreditsMenu.tscn")
	pass
	
func _on_Resume_pressed():
	visible = false
	button_sfx.play()
	get_tree().paused = false

func _on_Quit_pressed():
	button_sfx.play()
	get_tree().quit()
