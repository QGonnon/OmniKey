extends Node2D




func _ready():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Fade in")
	yield(get_tree().create_timer(4), "timeout")
	$AnimationPlayer.play("Fade out")
	$AudioStreamPlayer.stop()
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Scenes/Menu/MainMenu.tscn")
