extends Area2D

class_name Bullet

onready var animatedSprite := $AnimatedSprite

enum { MOVE, HIT }

var state = MOVE
var velocity = Vector2.ZERO

const DAMAGE = 1
const BULLET_SPEED = 800

func _ready():
	bullet_effect()
	Inventory.connect("weapon_changed", self, "bullet_effect")
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
#		HIT:
#			hit_state(delta)

func move_state(delta):
	position.y -= BULLET_SPEED * delta
	if position.y < 0:
		queue_free()
	
func bullet_effect():
	match Inventory.get_weapon_use():
		"AutoCannon":
			animatedSprite.play("AutoCannonBullet")
		"BigSpaceGun":
			animatedSprite.play("BigSpaceGun")
		"Rockets":
			animatedSprite.play("Rocket")
		"Zapper":
			animatedSprite.play("Zapper")


func _on_Bullet_area_entered(area):
	queue_free()
