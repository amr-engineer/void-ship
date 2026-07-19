extends StaticBody3D
class_name Tech


@onready var ship: Ship = $"../../../Ship"
@onready var power_cell_rack: RemoteTransform3D = $PowerCellRack
@onready var cpu_particles: CPUParticles3D = $CPUParticles3D

var health: float = 1.0


func _ready() -> void:
	if is_powered(): power_on()
	else: power_off()


func _process(_delta: float) -> void:
	if health < 0.25 && is_powered():
		ship.prnt("A System Got damaged and powered off")
		cpu_particles.show()
		remove_power_cell()


func fix() -> void:
	health = 1.0
	cpu_particles.hide()


func take_damage(dmg_mlt: float = 1.0) -> void:
	var dmg := randf_range(0.05, 1.0) * dmg_mlt
	health -= dmg
	ship.health -= dmg
	ship.prnt("Hull Health is %.0f" % (ship.health * 20))


func power_on() -> void:
	push_error("this should be overloaded")


func power_off() -> void:
	push_error("this should be overloaded")


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
