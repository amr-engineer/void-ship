extends StaticBody3D


@onready var ship: Ship = $"../../../Ship"


func interact() -> void:
	ship.next_camera()


func get_input_info() -> String:
	return "[E] Switch to next Optic Sensor"
