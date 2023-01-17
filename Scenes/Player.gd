extends KinematicBody2D

onready var base := $Bases
onready var weapons := $Bases/Weapons
onready var engines := $Bases/Engines
onready var engineEffects := $Bases/Engines/EngineEffects
onready var shields := $Bases/Shields
onready var hurtBox := $Hurtbox
onready var timer := $Timer

enum { MOVE, POWERING }

var state = MOVE
var engnieUse = "Base"
var weaponUse = "AutoCannon"
var velocity = Vector2.ZERO

const MAX_HEALTH = 4
const MAX_SPEED = 500
const ACCELERATION = 1000
const FRICTION = 5000

func _ready():
	base.play("FullHearth")
	weapons.play("AutoCannon")
	weapons.frame = 0
	engines.play("Base")
	engineEffects.play("BaseEngineIdle")
	shields.visible = false

func  _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
#		POWERING:
#			powering_state(delta)
			
func move_state(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	if input != Vector2.ZERO:
		engien_effect()
		velocity = velocity.move_toward(input * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	engien_effect()
	velocity = move_and_slide(velocity)

func engien_effect():
	if state == MOVE:
		match engnieUse:
			"Base":
				engineEffects.play("BaseEngineIdle")
	elif state == POWERING:
		match engnieUse:
			"Base":
				engineEffects.play("BaseEnginePowering")
