extends Tech


@onready var screen: Sprite3D = $Sprite3D


func power_on() -> void: return


func power_off() -> void:
	ship.prnt("Gun Autoloader stopped")


func interact() -> void:
	if ship.shot_ready:
		ship.shot()
	else:
		ship.gun_progress.value = ship.gun_progress.value + randi_range(1, 25)


func get_interact_info() -> String:
	if ship.shot_ready: return "[E] FIRE!"
	return "[E] Rapid Press to Speedup Ammo Loading"
