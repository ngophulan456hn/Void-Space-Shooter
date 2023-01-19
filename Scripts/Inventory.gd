extends Node

var engnieUse = "Base" setget set_engnie_use, get_engnie_use
var weaponUse = "AutoCannon" setget set_weapon_use, get_weapon_use

signal engnie_changed
signal weapon_changed

func set_engnie_use(engnie: String):
	engnieUse = engnie 
	emit_signal("engnie_changed")
	
func get_engnie_use() -> String:
	return engnieUse
	
func set_weapon_use(weapon: String):
	weaponUse = weapon
	emit_signal("weapon_changed")
	
func get_weapon_use() -> String:
	return weaponUse
	
