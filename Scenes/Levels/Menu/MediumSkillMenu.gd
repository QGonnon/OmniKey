extends CanvasLayer
onready var character = $"%Character"
onready var button_sfx = $"../../SFX_buttons"

var skillDesc = {
	"heal" : "Restaure une portion des points de vie du joueur.",
	"attackDamageBoost": "Augmente temporairement les dégâts infligés par les attaques du joueur."
}

onready var skillNameText = $Panel/SkillDescription/SkillName
onready var skillDescText = $Panel/SkillDescription/skillDesc

func _ready():
	var _error_code = $Panel/SkillsList/Button1.connect("pressed", self, "_on_Button_pressed", ["heal"])
	_error_code = $Panel/SkillsList/Button2.connect("pressed", self, "_on_Button_pressed", ["attackDamageBoost"])
	visible=false

func _on_Button_pressed(value: String):
	button_sfx.play()
	print(value + " sélectionné")
	if not PLAYERDATA.getValue("equippedArmor") == "medium":
		print("medium armor isn't equipped")
		return
		
	PLAYERDATA.setValue("selectedSkill", value)
	
	skillNameText.text = PLAYERDATA.getEquippedSkill().name+" :"
	skillDescText.text = skillDesc[value]
	
	character.skill1.active_timer.queue_free()
	character.skill1.cooldown_timer.queue_free()
	
	character.skill1 = Skill.new(value, character)
	EVENTS.emit_signal("changeSkillImage")
	character.add_child(character.skill1.active_timer)
	character.add_child(character.skill1.cooldown_timer)
