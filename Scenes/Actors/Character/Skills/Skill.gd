extends Node
class_name Skill

var sandWall = preload("res://Scenes/Actors/Character/Skills/SandWall/SandWall.tscn")
# Charger tous les sons ici
var speed_boost_sfx = preload("res://Themes/Audio/spellSpeed.wav")
var attack_speed_boost_sfx = preload("res://Themes/Audio/spellAttackSpeed.wav")
var attack_damage_boost_sfx = preload("res://Themes/Audio/spellDamage.wav")
var damage_reduction_sfx = preload("res://Themes/Audio/spellDefensiveShield.wav")
var heal_sfx = preload("res://Themes/Audio/spellHeal.wav")
var offensive_shield_sfx = preload("res://Themes/Audio/spellShield.wav")

var speedModifier = 1
var attackSpeedModifier = 1
var damageReductionModifier = 1
var attackDamageModifier = 1

var active_timer_duration
var active_timer = Timer.new()
var cooldown_timer_duration
var cooldown_timer = Timer.new()
var selectedSkill
var onNode
var selectedSkillNode

var sfx_player: AudioStreamPlayer  # Variable pour l'AudioStreamPlayer

func _init(skill: String, node: Node2D):
	onNode = node
	sfx_player = onNode.get_node("AudioStreamPlayer")  # Accéder à l'AudioStreamPlayer dans la scène
	if has_method(skill):
		selectedSkill = skill
	else:
		selectedSkill = "Error"
	match skill:
		"speedBoost":
			active_timer_duration = 10
			cooldown_timer_duration = 15
		"attackSpeedBoost":
			active_timer_duration = 8
			cooldown_timer_duration = 15
		"attackDamageBoost":
			active_timer_duration = 8
			cooldown_timer_duration = 15
		"damageReduction":
			active_timer_duration = 7
			cooldown_timer_duration = 15
		"heal":
			active_timer_duration = 0
			cooldown_timer_duration = 60
		"offensiveShield":
			active_timer_duration = 10
			cooldown_timer_duration = 15

	active_timer.one_shot = true
	active_timer.connect("timeout", self, "_on_active_timeout")
	cooldown_timer.one_shot = true

func activate():
	if active_timer.time_left == 0 and cooldown_timer.time_left == 0:
		if selectedSkill != "Error":
			if active_timer_duration > 0:
				active_timer.start(active_timer_duration)
				return call(selectedSkill, "Start")
			else:
				cooldown_timer.start(cooldown_timer_duration)
				return call(selectedSkill)
		call(selectedSkill)

func _on_active_timeout():
	call(selectedSkill, "End")
	cooldown_timer.start(cooldown_timer_duration)

func Error(_action: String):
	print("Skill inexistant")

# Chaque compétence joue son propre son à l'activation
func speedBoost(action: String):
	if action == "Start":
		speedModifier += 0.5
		play_sfx(speed_boost_sfx)  # Jouer le son de boost de vitesse
	elif action == "End":
		speedModifier -= 0.5

func attackSpeedBoost(action: String):
	if action == "Start":
		attackSpeedModifier += 0.5
		play_sfx(attack_speed_boost_sfx)  # Jouer le son d'augmentation de vitesse d'attaque
	elif action == "End":
		attackSpeedModifier -= 0.5

func attackDamageBoost(action: String):
	if action == "Start":
		attackDamageModifier += 0.25
		play_sfx(attack_damage_boost_sfx)  # Jouer le son d'augmentation des dégâts d'attaque
	elif action == "End":
		attackDamageModifier -= 0.25

func damageReduction(action: String):
	if action == "Start":
		damageReductionModifier += 1
		play_sfx(damage_reduction_sfx)  # Jouer le son de réduction des dégâts
	elif action == "End":
		damageReductionModifier -= 1

func heal():
	onNode.set_hp(onNode.get_hp() + 5)
	play_sfx(heal_sfx)  # Jouer le son de soin
	if onNode.get_hp() > onNode.max_hp:
		onNode.set_hp(onNode.max_hp)

func offensiveShield(action: String):
	if action == "Start":
		selectedSkillNode = sandWall.instance()
		onNode.add_child(selectedSkillNode)
		play_sfx(offensive_shield_sfx)  # Jouer le son du bouclier offensif
	elif action == "End":
		selectedSkillNode.queue_free()

# Fonction générique pour jouer un son
func play_sfx(sound: AudioStream):
	print('play sfx')
	sfx_player.stream = sound
	sfx_player.play()
