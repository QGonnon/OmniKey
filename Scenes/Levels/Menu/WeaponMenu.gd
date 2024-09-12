extends CanvasLayer

onready var character = $"%Character"

func _ready():
	
	# Connexion des boutons pour les armes à la fonction _on_Weapon_pressed
	var __ = $Panel/VBoxContainer/Weapon1.connect("pressed", self, "_on_Weapon_pressed", ["pistol"])
	__ = $Panel/VBoxContainer/Weapon2.connect("pressed", self, "_on_Weapon_pressed", ["shotgun"])
	__ = $Panel/VBoxContainer/Weapon3.connect("pressed", self, "_on_Weapon_pressed", ["assaultRifle"])
	
	# Connexion des boutons pour les actions sur les armes à la fonction _on_Weapon_pressed
#	__ = $Panel/VBoxContainer/Weapon2.connect("pressed", self, "_on_Weapon_pressed", ["shotgun"])
#	__ = $Panel/VBoxContainer/Weapon3.connect("pressed", self, "_on_Weapon_pressed", ["assaultRifle"])
	
	hide() # Hide the menu initially

func _on_Weapon_pressed(value):
	print(String(value) + " sélectionné")
