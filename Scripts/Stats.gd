extends Node

var max_health = 4 setget set_max_health, get_max_health
var spawn_position = Vector2.ZERO setget set_spawn_position, get_spawn_position

onready var health = max_health setget set_health, get_health

signal no_health
signal health_changed
signal max_health_changed(value)

func set_health(value: int):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed")
	if health <= 0:
		emit_signal("no_health")
	
func get_health() -> int:
	return health
	
func set_max_health(value: int):
	max_health = max(value, 1)
	emit_signal("max_health_changed", max_health)
	
func get_max_health() -> int:
	return max_health
	
func set_spawn_position(location: Vector2):
	spawn_position = location
	
func get_spawn_position():
	return spawn_position
