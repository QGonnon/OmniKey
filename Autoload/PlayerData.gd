extends Node

class_name PlayerData

var data = {
	"coins": 0,
	"skipIntro":false,
	"selectedSkill": "speedBoost",
	"equippedWeapon": "pistol",
	"weaponsLevel": {
		"pistol" : {
			"name" : "Pistolet",
			"level" :1,
			"basePrice" :10
		},
		"assaultRifle": {
			"name" : "Fusil d'assaut",
			"level" :0,
			"basePrice" :20
		},
		"shotgun": {
			"name" : "Fusil a pompe",
			"level" :0,
			"basePrice" :30
		}
	},
	"equippedArmor":"light",
	"armorsLevel":{
		"light" : {
			"name" : "Fantassin",
			"level" :1,
			"basePrice" :10
		},
		"medium": {
			"name" : "Mercenaire",
			"level" :0,
			"basePrice" :20
		},
		"heavy": {
			"name" : "Mastodonte",
			"level" :0,
			"basePrice" :30
		}
	}
}


var savePath = "user://playerData.save"

func _ready():
	load_data()
	GAME.set_nb_coins(data.coins)
	
func save():
	var save_file = File.new()
	save_file.open(savePath, File.WRITE)
	save_file.store_line(to_json(data))
	save_file.close()

func load_data():
	var save_file = File.new()
	if not save_file.file_exists(savePath):
		save()
	save_file.open(savePath, File.READ)
	data = parse_json(save_file.get_line())
	save_file.close()

func getEquippedWeapon():
	return data.weaponsLevel[data.equippedWeapon]

func getSelectedWeapon(selected: String):
	return data.weaponsLevel[selected]	

func getWeaponPrice(weaponName: String)->String:
	var weapon = data.weaponsLevel[weaponName]
	var price:int= weapon.basePrice*pow(1.1, weapon.level)
	return str(price)

func weaponLevelUp(armor:String):
	data.weaponsLevel[armor].level+=1
	save()

func getEquippedArmor():
	return data.armorsLevel[data.equippedWeapon]

func getSelectedArmor(selected: String):
	return data.armorsLevel[selected]	

func getArmorPrice(armorName: String)->String:
	var armor = data.armorsLevel[armorName]
	var price:int= armor.basePrice*pow(1.1, armor.level)
	return str(price)

func armorLevelUp(armor:String):
	data.armorsLevel[armor].level+=1
	save()

func setValue(property, value):
	if property in data:
		data[property] = value
	else:
		push_error(property+" doesn't exist")
	save()

func getValue(property):
	if property in data:
		return data[property]
	else:
		push_error(property+" doesn't exist")
