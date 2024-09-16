extends Node

class_name PlayerData

var data = {
	"coins": 0,
	"selectedSkill": "speedBoost",
	"selectedWeapon": "pistol",
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

func getSelectedWeapon():
	return data.weaponsLevel[data.selectedWeapon]

func getEquippedWeapon():
	return data.weaponsLevel[data.equippedWeapon]

func getWeaponPrice(weaponName: String)->String:
	var weapon = data.weaponsLevel[weaponName]
	var price:int= weapon.basePrice*pow(1.1, weapon.level)
	return str(price)

func weaponLevelUp(weapon:String):
	data.weaponsLevel[weapon].level+=1
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
