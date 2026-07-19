extends Node3D


@onready var world_environment: WorldEnvironment = $WorldEnvironment


func _ready() -> void:
	Config.config_updated.connect(_on_config_updated)
	_on_config_updated()


func _on_config_updated() -> void:
	world_environment.environment.ambient_light_energy = 0.1 * Config.get_value("graphics", "brightness", 1.0)
