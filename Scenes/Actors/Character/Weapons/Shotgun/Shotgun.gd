extends AnimatedSprite

onready var bullet = preload("res://Scenes/Actors/Shoot/projectile.tscn")
onready var shootingPoint = $ShootingPoint
onready var shoot_sfx = $AudioStreamPlayer  # Référence vers le AudioStreamPlayer

var weaponData = PLAYERDATA.getEquippedWeapon()

var damage = 0.25/pow(1.1, weaponData.level)
var delay = 1/pow(1.1, weaponData.level)
var delay_mili = delay*1000000
var lastShot = Time.get_ticks_usec()
var spread = 45

func shoot(modifyAttackSpeed):
	if Time.get_ticks_usec() > lastShot + (delay_mili/modifyAttackSpeed):
		var bullets = []
		for _i in range(7):
			var projectile_instance = bullet.instance()
			projectile_instance.CollisionLayer(2)
			projectile_instance.CollisionMask(1)
			
			play("shooting")  # Jouer l'animation "shooting"
			projectile_instance.global_position = position
			projectile_instance.rotation_degrees = rotation_degrees - rand_range(-spread/2, spread/2)
			projectile_instance.global_position = shootingPoint.global_position
			projectile_instance.scale *= 0.6
			projectile_instance.damage = damage
			
					# Jouer le son de tir
			shoot_sfx.play()
		
			bullets.append(projectile_instance)
		lastShot = Time.get_ticks_usec()
		return bullets
	return []
	
func _animationFinished():
	play("Idle") 

func _ready():
	play("Idle") 
	var __ = connect("animation_finished", self, "_animationFinished")

func _process(_delta):
	var rotaGun = int(rotation_degrees) % 360
	rotaGun = 360 + rotaGun if rotaGun < 0 else rotaGun
	var scaleGun = 0.6
	if 90 < rotaGun and rotaGun < 270:
		scale = Vector2(scaleGun, -scaleGun)
	else:
		scale = Vector2(scaleGun, scaleGun)
