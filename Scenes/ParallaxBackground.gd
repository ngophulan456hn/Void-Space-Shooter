extends ParallaxBackground

const SCROLL_SPEED = 100
const NEXT_STAR_FALL = 1

onready var animatedSprite := $StarFall/AnimatedSprite
onready var timer := $Timer
onready var starFall := $StarFall

var star_fall = false

func _ready():
	random_position_of_starfall()
	animatedSprite.frame = 0
	animatedSprite.play("Idle")
	
func _process(delta):
	scroll_offset.y += SCROLL_SPEED * delta
	if star_fall:
		star_fall = false
		animatedSprite.frame = 0
		animatedSprite.play("Idle")
		random_position_of_starfall()
		
func random_position_of_starfall():
	starFall.motion_mirroring.x = rand_range(36, 414)
	starFall.motion_mirroring.y = rand_range(640, 1280)

func _on_AnimatedSprite_animation_finished():
	timer.start(NEXT_STAR_FALL)

func _on_Timer_timeout():
	star_fall = true
