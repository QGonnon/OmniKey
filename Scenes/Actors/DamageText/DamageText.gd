extends Node2D
onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "_on_timeout")
	position = Vector2(rand_range(-20,20), rand_range(-30,0))

func _process(_delta):
	modulate.a = timer.time_left/timer.wait_time

func _on_timeout():
	queue_free()

func setText(value:String):
	$Label.text = value
