extends CanvasLayer

onready var button_sfx = $"../../SFX_buttons"
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

onready var SkillButton = $Panel/ArmorBrought/Skill

var selected = "light"

func _ready():
	visible=false
	var __ = $Panel/ArmorList/LightArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["light"])
	__ = $Panel/ArmorList/MediumArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["medium"])
	__ = $Panel/ArmorList/HeavyArmorsButton.connect("pressed", self, "_on_Armor_pressed", ["heavy"])

func _on_Armor_pressed(value: String):
	button_sfx.play()
	selectArmor(value)

func selectArmor(value: String):
	skills_menu[selected].hide()
	selected = value
	skills_menu[selected].show()
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
		if armor.level==5:
			$Panel/ArmorBrought/HSplitContainer.hide()
			$Panel/ArmorBrought/Upgrade.disabled=true
	armorNameDisplay.text = armor.name
	armorLevelDisplay.text = "Lvl."+str(armor.level)+"/5"
	armorBuyPriceDisplay.text = armorPrice
	armorUpgradePriceDisplay.text = armorPrice

#func _on_LightArmorsButton_pressed():
#	button_sfx.play()
#	if light_skills_menu.visible==false : 
#		hide_all_skill_menus()
#		light_skills_menu.visible=true
#
#func _on_MediumArmorsButton_pressed():
#	button_sfx.play()
#	if medium_skills_menu.visible==false : 
#		hide_all_skill_menus()
#		medium_skills_menu.visible=true
#
#func _on_HeavyArmorsButton_pressed():
#	button_sfx.play()
#	if heavy_skills_menu.visible==false : 
#		hide_all_skill_menus()
#		heavy_skills_menu.visible=true
#
#func hide_all_skill_menus():
#	light_skills_menu.visible=false
#	medium_skills_menu.visible=false
#	heavy_skills_menu.visible=false
