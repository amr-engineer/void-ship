extends Tech


@onready var screen: Sprite3D = $Sprite3D


func power_on() -> void:
	screen.modulate = Color.WHITE


func power_off() -> void:
	screen.modulate = Color.BLACK


func interact() -> void:
	if is_powered():
		if ship.ftl_ready:
			ship.tp()
		else:
			ship.nav_progress.value = ship.nav_progress.value + randf_range(0.05, 0.5)


func get_interact_info() -> String:
	if ship.ftl_ready: return "[E] Go to Next Position"
	return "[E] Rapid Press to Speedup Calibration"
