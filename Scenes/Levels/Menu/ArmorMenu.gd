extends CanvasLayer

onready var light_skills_menu = get_node("/root/Level/LightSkillsMenu")
onready var medium_skills_menu = get_node("/root/Level/MediumSkillsMenu")
onready var heavy_skills_menu = get_node("/root/Level/HeavySkillsMenu")
onready var lightArmorsButton = $Panel/VBoxContainer/LightArmorsButton
onready var mediumArmorsButton = $Panel/VBoxContainer/MediumArmorsButton
onready var heavyArmorsButton = $Panel/VBoxContainer/HeavyArmorsButton

func _ready():
	lightArmorsButton.connect("pressed", self, "_on_LightArmorsButton_pressed")
	mediumArmorsButton.connect("pressed", self, "_on_MediumArmorsButton_pressed")
	heavyArmorsButton.connect("pressed", self, "_on_HeavyArmorsButton_pressed")
	hide()

func _on_LightArmorsButton_pressed():
	if lightArmorsButton : 
		print("print light réussit")
		print(lightArmorsButton)
		print(light_skills_menu)
		hide_all_skill_menus()
		light_skills_menu.show()
	else :
		print("print light raté")

func _on_MediumArmorsButton_pressed():
	if mediumArmorsButton : 
		print("print medium réussit")
		print(mediumArmorsButton)
		print(medium_skills_menu)
		hide_all_skill_menus()
		medium_skills_menu.show()
	else :
		print("print medium raté")

func _on_HeavyArmorsButton_pressed():
	if heavyArmorsButton : 
		print("print heavy réussit")
		print(heavyArmorsButton)
		print(heavy_skills_menu)
		hide_all_skill_menus()
		heavy_skills_menu.show()
	else :
		print("print heavy raté")

func hide_all_skill_menus():
	light_skills_menu.hide()
	medium_skills_menu.hide()
	heavy_skills_menu.hide()
