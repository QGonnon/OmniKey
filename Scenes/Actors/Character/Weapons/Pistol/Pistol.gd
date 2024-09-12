extends AnimatedSprite

onready var bullet = preload("res://Scenes/Actors/Shoot/projectile.tscn")
onready var shootingPoint = $ShootingPoint

var delay = 0.75
var countTime = delay

func shoot(delta):
	countTime += delta
	if countTime > delay:
		var projectile_instance = bullet.instance()
		projectile_instance.CollisionLayer(2)
		projectile_instance.CollisionMask(1)
		
		play("shooting")  # Jouer l'animation "shooting"
		projectile_instance.global_position = position
		projectile_instance.rotation = rotation
		projectile_instance.global_position = shootingPoint.global_position
		
		countTime = 0
		return projectile_instance

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
