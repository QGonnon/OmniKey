extends Node

class_name PlayerData

var data = {
	"coins": 0,
	"skipIntro":false,
	"equippedWeapon": "pistol",
	"weaponsLevel": {
		"pistol" : {
			"name" : "Pistolet",
			"level" :1,
			"basePrice" :100
		},
		"assaultRifle": {
			"name" : "Fusil d'assaut",
			"level" :0,
			"basePrice" :100
		},
		"shotgun": {
			"name" : "Fusil a pompe",
			"level" :0,
			"basePrice" :100
		}
	},
	"equippedArmor":"light",
	"armorsLevel":{
		"light" : {
			"name" : "Fantassin",
			"level" :1,
			"basePrice" :100
		},
		"medium": {
			"name" : "Mercenaire",
			"level" :0,
			"basePrice" :100
		},
		"heavy": {
			"name" : "Mastodonte",
			"level" :0,
			"basePrice" :100
		}
	},
	"selectedSkill": "speedBoost",
	"skillsLevel":{
		"speedBoost" : {
			"name" : "Vitesse supersonique",
			"level" :1,
			"basePrice" :100,
			"active_duration": 10,
			"cooldown_duration" : 15
		},
		"attackSpeedBoost": {
			"name" : "Balles a haute velocite",
			"level" :0,
			"basePrice" :100,
			"active_duration": 8,
			"cooldown_duration" : 15
		},
		"heal": {
			"name" : "Piqure revigorante",
			"level" :1,
			"basePrice" :100,
			"active_duration": 0,
			"cooldown_duration" : 60
		},
		"attackDamageBoost": {
			"name" : "Balles perforantes",
			"level" :0,
			"basePrice" :100,
			"active_duration": 8,
			"cooldown_duration" : 15
		},
		"damageReduction" : {
			"name" : "Renforcement ultime",
			"level" :1,
			"basePrice" :100,
			"active_duration": 7,
			"cooldown_duration" : 15
		},
		"offensiveShield": {
			"name" : "Bouclier d'ondes",
			"level" :0,
			"basePrice" :100,
			"active_duration": 10,
			"cooldown_duration" : 15
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
	return data.armorsLevel[data.equippedArmor]

func getSelectedArmor(selected: String):
	return data.armorsLevel[selected]	

func getArmorPrice(armorName: String)->String:
	var armor = data.armorsLevel[armorName]
	var price:int= armor.basePrice*pow(1.1, armor.level)
	return str(price)

func armorLevelUp(armor:String):
	data.armorsLevel[armor].level+=1
	save()

func getEquippedSkill():
	return data.skillsLevel[data.selectedSkill]

func getSelectedSkill(selected: String):
	return data.skillsLevel[selected]	

func getSkillPrice(skillName: String)->String:
	var skill = data.skillsLevel[skillName]
	var price:int= skill.basePrice*pow(1.1, skill.level)
	return str(price)

func skillLevelUp(skill:String):
	data.skillsLevel[skill].level+=1
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
