extends Area2D

class_name Asteroid

onready var animatedSprite := $AnimatedSprite
onready var collisionShape2D := $CollisionShape2D
onready var spriteEffect := $SpriteEffect
onready var hurtBox = $Hurtbox
onready var stats := $Stats

enum { IDLE, EXPLODE }

var state = IDLE
var velocity = Vector2.ZERO

const MAX_SPEED = 100
const ROTATED_SPEED = 5

var asteroid_max_health: int = 3

func _ready():
	stats.set_max_health(asteroid_max_health)
	stats.set_health(asteroid_max_health) 
	stats.connect("no_health", self, "_on_no_health")
	animatedSprite.play("Base")
	spriteEffect.play("Effect")
	
func _physics_process(delta):
	match state:
		IDLE: 
			move_state(delta)
		EXPLODE:
			explode_state()
	
func move_state(delta):
	animatedSprite.rotation_degrees += ROTATED_SPEED
	position.y += MAX_SPEED * delta
	if position.y > 650:
		queue_free()
		
func explode_state():
	animatedSprite.play("Explode")
	spriteEffect.visible = false
	hurtBox.disable_collision()
	collisionShape2D.disabled = true
	
func _on_no_health():
	state = EXPLODE
	spriteEffect.visible = false

func _on_AnimatedSprite_animation_finished():
	if state == EXPLODE:
		queue_free()

func _on_Hurtbox_area_entered(area):
	if area is Bullet:
		stats.set_health(stats.get_health() - 1)
	print("Asteroid health: ", stats.get_health())


func _on_Asteroids_body_entered(body):
	if body is Player:
		state = EXPLODE
