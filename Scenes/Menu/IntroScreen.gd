extends Node2D




func _ready():
	$AnimationPlayer.play("Fade in")
	yield(get_tree().create_timer(1), "timeout")
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(2), "timeout")
	$AudioStreamPlayer.stop()
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("Fade out")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Scenes/Menu/MainMenu.tscn")
