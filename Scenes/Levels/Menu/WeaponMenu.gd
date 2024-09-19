extends CanvasLayer

onready var character = $"%Character"
onready var button_sfx = $"../../SFX_buttons"
onready var weapons = {
	"pistol": preload("res://Scenes/Actors/Character/Weapons/Pistol/Pistol.tscn"),
	"shotgun": preload("res://Scenes/Actors/Character/Weapons/Shotgun/Shotgun.tscn"),
	"assaultRifle": preload("res://Scenes/Actors/Character/Weapons/AssaultRifle/AssaultRifle.tscn"),
}

onready var weaponBroughtMenu = $Panel/WeaponBrought
onready var weaponToBuyMenu = $Panel/WeaponToBuy
onready var weaponNameDisplay = $Panel/WeaponDescription/HSplitContainer/weaponSelected
onready var weaponLevelDisplay = $Panel/WeaponDescription/HSplitContainer/weaponLevelSelected
onready var weaponBuyPriceDisplay = $Panel/WeaponToBuy/HSplitContainer/value
onready var weaponUpgradePriceDisplay = $Panel/WeaponBrought/HSplitContainer/value

var selected = "pistol"

func _ready():
	# Connexion des boutons pour les armes à la fonction _on_Weapon_pressed
	var __ = $Panel/WeaponList/Weapon1.connect("pressed", self, "_on_Weapon_pressed", ["pistol"])
	__ = $Panel/WeaponList/Weapon2.connect("pressed", self, "_on_Weapon_pressed", ["shotgun"])
	__ = $Panel/WeaponList/Weapon3.connect("pressed", self, "_on_Weapon_pressed", ["assaultRifle"])
	
	# Connexion des boutons pour les actions sur les armes à la fonction _on_Weapon_pressed
	__ = $Panel/WeaponBrought/Select.connect("pressed", self, "_on_Select_pressed")
	__ = $Panel/WeaponBrought/Upgrade.connect("pressed", self, "_on_Upgrade_pressed")
	__ = $Panel/WeaponToBuy/Buy.connect("pressed", self, "_on_Upgrade_pressed")
	
	hide() # Hide the menu initially
	selectWeapon(selected)

func _on_Weapon_pressed(value: String):
	button_sfx.play()
	selectWeapon(value)
	
func selectWeapon(value: String):
	selected = value
	var weaponPrice = PLAYERDATA.getWeaponPrice(selected)
	var weapon = PLAYERDATA.getSelectedWeapon(selected)
	if weapon.level == 0:
		weaponBroughtMenu.hide()
		weaponToBuyMenu.show()
	else:
		weaponToBuyMenu.hide()
		weaponBroughtMenu.show()
		$Panel/WeaponBrought/HSplitContainer.show()
		$Panel/WeaponBrought/Upgrade.disabled=false
		if weapon.level==5:
			$Panel/WeaponBrought/HSplitContainer.hide()
			$Panel/WeaponBrought/Upgrade.disabled=true
	weaponNameDisplay.text = weapon.name
	weaponLevelDisplay.text = "Lvl."+str(weapon.level)+"/5"
	weaponBuyPriceDisplay.text = weaponPrice
	weaponUpgradePriceDisplay.text = weaponPrice
			
func _on_Select_pressed():
	button_sfx.play()
	PLAYERDATA.setValue("equippedWeapon", selected)
	character.weapon.queue_free()
	character.weapon = weapons[PLAYERDATA.getValue("equippedWeapon")].instance()
	character.add_child(character.weapon)

func _on_Upgrade_pressed():
	button_sfx.play()
	var weaponPrice = PLAYERDATA.getWeaponPrice(selected)
	var weapon = PLAYERDATA.getSelectedWeapon(selected)
	if int(weaponPrice) <= GAME.get_nb_coins() && weapon.level<5:
		PLAYERDATA.weaponLevelUp(selected)
		GAME.set_nb_coins(GAME.get_nb_coins()-int(weaponPrice))
		selectWeapon(selected)
#	GAME.set_nb_coins(GAME.get_nb_coins()+1)

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		GAME.set_nb_coins(GAME.get_nb_coins()+10)
		
