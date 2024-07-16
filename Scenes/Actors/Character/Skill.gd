extends Node
class_name Skill

var speedModifier = 1

var active_timer_duration
var active_timer = Timer.new()
var cooldown_timer_duration
var cooldown_timer = Timer.new()
var selectedSkill

func _init(skill:String):
	if has_method(skill+"Start"):
		selectedSkill = skill
	else:
		selectedSkill = "Error"
	match skill:
		"boost":
			active_timer_duration = 10
			cooldown_timer_duration = 5
	
	active_timer.one_shot=true
	active_timer.connect("timeout", self, "_on_active_timeout")
	
	cooldown_timer.one_shot=true

func activate():
	if active_timer.time_left==0 and cooldown_timer.time_left ==0:
		if selectedSkill == "Error":
			call(selectedSkill)
		else:
			active_timer.start(active_timer_duration)
			call(selectedSkill+"Start")
	
func _on_active_timeout():
	call(selectedSkill+"End")
	cooldown_timer.start(cooldown_timer_duration)
	
func Error():
	print("Skill inexistant")

func boostStart():
	speedModifier += 1

func boostEnd():
	speedModifier -= 1
