extends Tech


@onready var screen: Sprite3D = $Sprite3D


func power_on() -> void:
	screen.modulate = Color.WHITE


func power_off() -> void:
	screen.modulate = Color.BLACK


func interact() -> void:
	if is_powered(): ship.next_camera()


func get_interact_info() -> String:
	return "[E] Switch to next Optic Sensor"
