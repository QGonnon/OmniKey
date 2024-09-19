extends StaticBody2D

onready var state_machine = $StateMachine
onready var animated_sprite = $AnimatedSprite
onready var openChest_SFX = $openChestSFX  # Référence vers le AudioStreamPlayer

func interact() -> void:
	if state_machine.get_state_name() == "Idle":
		state_machine.set_state("Open")
		openChest_SFX.play()
		EVENTS.emit_signal("chest_opened", global_position)
		animated_sprite.play("Open")



func _on_AnimatedSprite_animation_finished() -> void:
	state_machine.set_state("Opened")
