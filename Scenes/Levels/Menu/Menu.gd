extends Node2D

onready var light_skills_menu = $"../LightSkillsMenu/CanvasLayer"
onready var medium_skills_menu = $"../MediumSkillsMenu/CanvasLayer"
onready var heavy_skills_menu = $"../HeavySkillsMenu/CanvasLayer"

func _ready():
	$Area.connect("body_entered", self, "_on_body_entered")
	$Area.connect("body_exited", self, "_on_body_exited")
	
func hide_all_skill_menus():
	light_skills_menu.visible=false
	medium_skills_menu.visible=false
	heavy_skills_menu.visible=false
	
func _on_body_entered(body):
	if body.name == "Character":
		$CanvasLayer.show()

func _on_body_exited(body):
	if body.name == "Character":
		$CanvasLayer.hide()
		hide_all_skill_menus()
