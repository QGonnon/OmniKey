extends TextureRect

onready var coin_counter = $CoinCounter
onready var btnPause = $Pause
onready var menuPause = $"../PauseMenu/CanvasLayer"

func _ready() -> void:
	var __ = EVENTS.connect("nb_coins_changed", self, "_on_EVENTS_nb_coins_changed")
	__ = EVENTS.connect("character_hp_changed", self, "_on_EVENTS_character_hp_changed")
	$CoinCounter.text = str(GAME.get_nb_coins())

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		print("btnPause pressed")
		print(menuPause)
		menuPause.visible = true
		get_tree().paused = true
	

func _on_EVENTS_nb_coins_changed(nb_coins: int) -> void:
	coin_counter.set_text(String(nb_coins))

func _on_pause_pressed():
	print("btnPause pressed")
	$"../PauseMenu".visible = true

func _on_EVENTS_character_hp_changed(hp: int) -> void:
	$HP_Bar.set_value(hp)
