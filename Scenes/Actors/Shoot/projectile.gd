extends Area2D

var speed = 1000
var damage = 1  # Définir les dégâts infligés par la balle
var type

func _ready():
	connect("body_entered", self, "_on_Projectile_body_entered")

func CollisionMask(CollisionLayer:int):
	set_collision_mask_bit(CollisionLayer-1,true)

func CollisionLayer(CollisionLayer:int):
	set_collision_layer_bit(CollisionLayer-1,true)
	
	
func _process(delta):
	position += Vector2(1,0).rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Projectile_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(damage)
	
	if body.has_method("destroy"):
		body.destroy()
	
	if body.has_method("interact"):
		body.interact()
	queue_free()
