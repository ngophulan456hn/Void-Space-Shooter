extends KinematicBody2D

class_name Player

const Bullet = preload("res://Scenes/Bullet.tscn")

onready var base := $Bases
onready var weapons := $Bases/Weapons
onready var engines := $Bases/Engines
onready var engineEffects := $Bases/Engines/EngineEffects
onready var shields := $Bases/Shields
onready var hurtBox := $Hurtbox
onready var timer := $Timer
onready var collisionShape2D := $CollisionShape2D

enum { MOVE, POWERING }

var state = MOVE
var velocity = Vector2.ZERO
var weapon_animation_finished = true

const MAX_HEALTH = 4
const MAX_SPEED = 350
const ACCELERATION_TIME = 2
const ACCELERATION = 1000
const FRICTION = 5000

func _ready():
	base.play("FullHearth")
	shields.visible = false
	Stats.connect("no_health", self, "_on_no_health")
	Stats.connect("health_changed", self, "_on_health_changed")
	Stats.set_max_health(MAX_HEALTH)
	Stats.set_spawn_position(self.global_position)
	Inventory.connect("engnie_changed", self, "_on_engnie_changed")
	Inventory.connect("weapon_changed", self, "_on_weapon_changed")
	engineEffects.speed_scale = ACCELERATION_TIME
#	_on_engnie_changed()
#	_on_weapon_changed()
	engien_effect()

func  _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	input = input.normalized()
	
	if Input.is_action_pressed("ui_acceleration"):
		state = POWERING
		
	if Input.is_action_pressed("ui_shoot"):
		spawn_bullet()
		_on_weapon_changed()
	
	match state:
		MOVE:
			move_state(input, delta)
		POWERING:
			powering_state(input, delta)
	
	limit_movement()
	engien_effect()
	velocity = move_and_slide(velocity)
	
func move_state(input,delta):
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
func powering_state(input,delta):
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * MAX_SPEED * ACCELERATION_TIME, ACCELERATION * ACCELERATION_TIME * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if Input.is_action_just_released("ui_acceleration"):
		state = MOVE
		
func limit_movement():
	var playerSize = collisionShape2D.shape.extents
	var screenSize := get_viewport_rect()
	self.global_position.x = clamp(self.global_position.x, 0 + playerSize.x, screenSize.size.x - playerSize.x)
	self.global_position.y = clamp(self.global_position.y, 0 + playerSize.y * 2, screenSize.size.y - playerSize.y)

func engien_effect():
	if state == MOVE:
		match Inventory.engnieUse:
			"Base":
				engineEffects.play("BaseEngineIdle")
			"BigPulse":
				engineEffects.play("BigPulseIdle")
			"Burst":
				engineEffects.play("BurstEngineIdle")
			"Supercharged":
				engineEffects.play("SuperchargedIdle")
	elif state == POWERING:
		match Inventory.engnieUse:
			"Base":
				engineEffects.play("BaseEnginePowering")
			"BigPulse":
				engineEffects.play("BigPulsePowering")
			"Burst":
				engineEffects.play("BurstEnginePowering")
			"Supercharged":
				engineEffects.play("SuperchargedPowering")

func ship_condition():
	match Stats.get_health():
		4:
			base.play("FullHearth")
		3:
			base.play("SlightDamage")
		2:
			base.play("Damaged")
		1:
			base.play("VeryDamaged")
	
func _on_Hurtbox_area_entered(area):
	print("_on_Hurtbox_area_entered")
	#Stats.set_health(Stats.get_health() - 1)
	hurtBox.start_invincibility(0.6)
	
func _on_no_health():
	self.global_position = Stats.get_spawn_position()
	Stats.set_max_health(Stats.get_max_health())
	Stats.set_health(Stats.get_max_health())

func _on_health_changed():
	ship_condition()
	
func _on_engnie_changed():
	match Inventory.get_engnie_use():
		"Base":
			engines.play("Base")
		"BigPulse":
			engines.play("BigPulse")
		"Burst":
			engines.play("Burst")
		"Supercharged":
			engines.play("Supercharged")
			
func _on_weapon_changed():
	if weapon_animation_finished:
		match Inventory.get_weapon_use():
			"AutoCannon":
				weapons.play("AutoCannon")
			"BigSpaceGun":
				weapons.play("BigSpaceGun")
			"Rockets":
				weapons.play("Rockets")
			"Zapper":
				weapons.play("Zapper")
		weapon_animation_finished = false
		
func spawn_bullet():
	var bullet = Bullet.instance()
	bullet.global_position = self.global_position
	get_parent().add_child(bullet)
	

func _on_Weapons_animation_finished():
	weapon_animation_finished = true
	weapons.frame = 0
	weapons.playing = false

