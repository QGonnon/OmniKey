extends CanvasLayer

onready var light_skills_menu = $"../../LightSkillsMenu/CanvasLayer"
onready var medium_skills_menu = $"../../MediumSkillsMenu/CanvasLayer"
onready var heavy_skills_menu = $"../../HeavySkillsMenu/CanvasLayer"
onready var lightArmorsButton = $Panel/VBoxContainer/LightArmorsButton
onready var mediumArmorsButton = $Panel/VBoxContainer/MediumArmorsButton
onready var heavyArmorsButton = $Panel/VBoxContainer/HeavyArmorsButton

func _ready():
	visible=false
	lightArmorsButton.connect("pressed", self, "_on_LightArmorsButton_pressed")
	mediumArmorsButton.connect("pressed", self, "_on_MediumArmorsButton_pressed")
	heavyArmorsButton.connect("pressed", self, "_on_HeavyArmorsButton_pressed")

func _on_LightArmorsButton_pressed():
	if lightArmorsButton : 
		hide_all_skill_menus()
		light_skills_menu.visible=true
	else :
		print("print light raté")

func _on_MediumArmorsButton_pressed():
	if mediumArmorsButton : 
		hide_all_skill_menus()
		medium_skills_menu.visible=true
	else :
		print("print medium raté")

func _on_HeavyArmorsButton_pressed():
	if heavyArmorsButton : 
		hide_all_skill_menus()
		heavy_skills_menu.visible=true
	else :
		print("print heavy raté")

func hide_all_skill_menus():
	light_skills_menu.visible=false
	medium_skills_menu.visible=false
	heavy_skills_menu.visible=false
