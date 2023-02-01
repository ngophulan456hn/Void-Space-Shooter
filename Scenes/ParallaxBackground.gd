extends ParallaxBackground

const SCROLL_SPEED = 100

func _ready():
	pass 

func _process(delta):
	scroll_offset.y += SCROLL_SPEED * delta
