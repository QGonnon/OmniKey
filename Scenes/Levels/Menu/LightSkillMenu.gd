extends CanvasLayer
onready var character = $"%Character"

func _ready():
	
	$Panel/VBoxContainer/Button1.connect("pressed", self, "_on_Button_pressed", ["speedBoost"])
	$Panel/VBoxContainer/Button2.connect("pressed", self, "_on_Button_pressed", ["attackSpeedBoost"])
	visible=false

func _on_Button_pressed(value: String):
	print(value + " sélectionné")
	character.skill1.active_timer.queue_free()
	character.skill1.cooldown_timer.queue_free()
	
	character.skill1 = Skill.new(value)
	character.add_child(character.skill1.active_timer)
	character.add_child(character.skill1.cooldown_timer)
