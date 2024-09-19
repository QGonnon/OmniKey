extends CanvasLayer
onready var character = $"%Character"
onready var button_sfx = $"../../SFX_buttons"

var skillDesc = {
	"damageReduction" : "bonjour",
	"offensiveShield": "au revoir"
}

onready var skillNameText = $Panel/SkillDescription/SkillName
onready var skillDescText = $Panel/SkillDescription/skillDesc

func _ready():
	var __ = $Panel/SkillsList/Button1.connect("pressed", self, "_on_Button_pressed", ["damageReduction"])
	__ = $Panel/SkillsList/Button2.connect("pressed", self, "_on_Button_pressed", ["offensiveShield"])
	visible=false

func _on_Button_pressed(value: String):
	button_sfx.play()
	print(value + " sélectionné")
	if not PLAYERDATA.getValue("equippedArmor") == "heavy":
		print("heavy armor isn't equipped")
		return
	
	PLAYERDATA.setValue("selectedSkill", value)
	
	skillNameText.text = PLAYERDATA.getEquippedSkill().name
	skillDescText.text = skillDesc[value]
	
	character.skill1.active_timer.queue_free()
	character.skill1.cooldown_timer.queue_free()
	
	character.skill1 = Skill.new(value, character)
	character.add_child(character.skill1.active_timer)
	character.add_child(character.skill1.cooldown_timer)
