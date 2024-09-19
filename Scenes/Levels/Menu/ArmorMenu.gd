extends CanvasLayer

onready var button_sfx = $"../../SFX_buttons"
onready var upgradeOrBuyArmors_sfx = $"../../SFX_upgradeOrBuy"
onready var character = $"%Character"
onready var skills_menu = {
	"light": $"../../LightSkillsMenu/CanvasLayer",
	"medium": $"../../MediumSkillsMenu/CanvasLayer",
	"heavy": $"../../HeavySkillsMenu/CanvasLayer",
}
onready var armorBroughtMenu = $Panel/ArmorBrought
onready var armorToBuyMenu = $Panel/ArmorToBuy
onready var armorNameDisplay = $Panel/ArmorDescription/HSplitContainer/armorSelected
onready var armorLevelDisplay = $Panel/ArmorDescription/HSplitContainer/armorLevelSelected
onready var armorBuyPriceDisplay = $Panel/ArmorToBuy/HSplitContainer/value
onready var armorUpgradePriceDisplay = $Panel/ArmorBrought/HSplitContainer/value

var selected = "light"

func _ready():
	visible=false
	var __ = $Panel/ArmorList/LightArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["light"])
	__ = $Panel/ArmorList/MediumArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["medium"])
	__ = $Panel/ArmorList/HeavyArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["heavy"])
	
	__ = $Panel/ArmorBrought/Select.connect("pressed", self, "_on_Select_pressed")
	__ = $Panel/ArmorBrought/Skill.connect("pressed", self, "_on_ShowSkill_pressed")
	__ = $Panel/ArmorBrought/Upgrade.connect("pressed", self, "_on_Upgrade_pressed")
	__ = $Panel/ArmorToBuy/Buy.connect("pressed", self, "_on_Upgrade_pressed")
	selectArmor(selected)
	
func _on_Armor_pressed(value: String):
	button_sfx.play()
	selectArmor(value)

func selectArmor(value: String):
	skills_menu[selected].hide()
	selected = value
	var armorPrice = PLAYERDATA.getArmorPrice(selected)
	var armor = PLAYERDATA.getSelectedArmor(selected)
	if armor.level == 0:
		armorBroughtMenu.hide()
		armorToBuyMenu.show()
	else:
		armorToBuyMenu.hide()
		armorBroughtMenu.show()
		$Panel/ArmorBrought/HSplitContainer.show()
		$Panel/ArmorBrought/Upgrade.disabled=false
		$Panel/ArmorBrought/Skill.disabled=true
		$Panel/ArmorBrought/Select.disabled = false
		if armor.level==5:
			$Panel/ArmorBrought/HSplitContainer.hide()
			$Panel/ArmorBrought/Upgrade.disabled=true
		if PLAYERDATA.getSelectedArmor(selected) == PLAYERDATA.getEquippedArmor():
			$Panel/ArmorBrought/Select.disabled = true
			$Panel/ArmorBrought/Skill.disabled = false
	armorNameDisplay.text = armor.name
	armorLevelDisplay.text = "Lvl."+str(armor.level)+"/5"
	armorBuyPriceDisplay.text = armorPrice
	armorUpgradePriceDisplay.text = armorPrice

func _on_ShowSkill_pressed():
	skills_menu[selected].show()

func _on_Upgrade_pressed():
	button_sfx.play()
	var armorPrice = PLAYERDATA.getArmorPrice(selected)
	var armor = PLAYERDATA.getSelectedArmor(selected)
	if int(armorPrice) <= GAME.get_nb_coins() && armor.level<5:
		upgradeOrBuyArmors_sfx.play()
		PLAYERDATA.armorLevelUp(selected)
		GAME.set_nb_coins(GAME.get_nb_coins()-int(armorPrice))
		selectArmor(selected)
		
func _on_Select_pressed():
	PLAYERDATA.setValue("equippedArmor", selected)
	var armor = PLAYERDATA.getEquippedArmor()
	character.max_hp = character.health * armor.healthModifier
	character.speed = character.move_speed * armor.speedModifier
	EVENTS.emit_signal("character_max_hp_changed", character.max_hp)
	character.emit_signal("hp_changed", character.max_hp)
	selectArmor(selected)
	
	var skillToSet
	match selected:
		"light":
			skillToSet="speedBoost"
		"medium":
			skillToSet="heal"
		"heavy":
			skillToSet="damageReduction"
			
	PLAYERDATA.setValue("selectedSkill", skillToSet)
	character.skill1.active_timer.queue_free()
	character.skill1.cooldown_timer.queue_free()
	
	character.skill1 = Skill.new(skillToSet, character)
	character.add_child(character.skill1.active_timer)
	character.add_child(character.skill1.cooldown_timer)
