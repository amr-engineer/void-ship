extends StaticBody3D


@onready var ship: Ship = $"../../../Ship"
@onready var power_cell_rack: RemoteTransform3D = $PowerCellRack
@onready var screen: Sprite3D = $Sprite3D


func _ready() -> void:
	if is_powered(): power_on()
	else: power_off()


func power_on() -> void:
	screen.modulate = Color.WHITE


func power_off() -> void:
	screen.modulate = Color.BLACK


func interact() -> void:
	if is_powered(): ship.next_camera()


func get_interact_info() -> String:
	return "[E] Switch to next Optic Sensor"


func is_powered() -> bool:
	return power_cell_rack.has_node(power_cell_rack.remote_path)


func install_power_cell(cell: PowerCell) -> void:
	power_cell_rack.remote_path = power_cell_rack.get_path_to(cell)
	cell.position = power_cell_rack.position
	cell.powering = self
	cell.freeze = true

	power_on()


func remove_power_cell() -> void:
	var cell: PowerCell = power_cell_rack.get_node(power_cell_rack.remote_path)
	cell.freeze = false
	cell.powering = null
	power_cell_rack.remote_path = ""

	power_off()
