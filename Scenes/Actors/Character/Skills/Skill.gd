extends Node
class_name Skill

var sandWall = preload("res://Scenes/Actors/Character/Skills/SandWall/SandWall.tscn")

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

func _init(skill:String, node: Node2D):
	onNode = node
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
	
	active_timer.one_shot=true
	active_timer.connect("timeout", self, "_on_active_timeout")
	
	cooldown_timer.one_shot=true

func activate():
	if active_timer.time_left==0 and cooldown_timer.time_left==0:
		if selectedSkill != "Error":
			if active_timer_duration>0:
				active_timer.start(active_timer_duration)
				return call(selectedSkill,"Start")
			else:
				cooldown_timer.start(cooldown_timer_duration)
				return call(selectedSkill)
		call(selectedSkill)
	
func _on_active_timeout():
	call(selectedSkill,"End")
	cooldown_timer.start(cooldown_timer_duration)
	
func Error(_action:String):
	print("Skill inexistant")

func speedBoost(action:String):
	if action == "Start":
		speedModifier += 0.5
	elif action == "End":
		speedModifier -= 0.5

func attackSpeedBoost(action:String):
	if action == "Start":
		attackSpeedModifier += 0.5
	elif action == "End":
		attackSpeedModifier -= 0.5

func attackDamageBoost(action:String):
	if action == "Start":
		attackDamageModifier += 0.25
	elif action == "End":
		attackDamageModifier -= 0.25

func damageReduction(action:String):
	if action == "Start":
		damageReductionModifier += 1
	elif action == "End":
		damageReductionModifier -= 1

func heal():
	onNode.set_hp(onNode.get_hp()+5)
	if onNode.get_hp()>onNode.max_hp:
		onNode.set_hp(onNode.max_hp)

func offensiveShield(action:String):
	if action == "Start":
		selectedSkillNode = sandWall.instance()
		onNode.add_child(selectedSkillNode)
	elif action == "End":
		selectedSkillNode.queue_free()
