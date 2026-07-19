extends Node3D
class_name Game


@onready var world_environment: WorldEnvironment = $WorldEnvironment

var enemy : Node


func _ready() -> void:
	Config.config_updated.connect(_on_config_updated)
	_on_config_updated()


func _on_config_updated() -> void:
	world_environment.environment.ambient_light_energy = 0.1 * Config.get_value("graphics", "brightness", 1.0)
