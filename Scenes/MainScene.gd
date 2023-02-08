extends Node2D

var Asteroids = load("res://Scenes/Asteroids.tscn")

onready var timer := $Timer

const MAX_ASTEROIDS = 10
var number_spawn = 0
var spawn_again = true

func _ready():
	pass
	
func _physics_process(delta):
	if spawn_again and number_spawn < MAX_ASTEROIDS:
		spawn_asteroids()
		number_spawn += 1
		print(number_spawn)
		timer.start(1)
		spawn_again = false
	
func spawn_location():
	var location = Vector2.ZERO
	location.x = rand_range(20, 580)
	location.y = -60
	return location
	
func spawn_asteroids():
	var asteroid = Asteroids.instance()
	add_child(asteroid)
	asteroid.global_position = spawn_location()

func _on_Timer_timeout():
	spawn_again = true
