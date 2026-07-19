extends Node3D
class_name Game


@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var console: RichTextLabel = $Ship/console/SubViewport/RichTextLabel

var enemy: Enemy


func _ready() -> void:
	Config.config_updated.connect(_on_config_updated)
	_on_config_updated()


func _on_config_updated() -> void:
	world_environment.environment.ambient_light_energy = 0.1 * Config.get_value("graphics", "brightness", 1.0)


func prnt(line: String) -> void:
	console.add_text("\n" + line)


func next() -> void:
	if randi_range(0, 10) == 0:
		enemy = null
		prnt("Only Rocks displayed on Radar")
	else:
		enemy = Enemy.new()
		var enemy_type := "Ship"

		if enemy.damage_mult >= 2.0 || enemy.attack_speed < 3: enemy_type = "Fighter " + enemy_type
		if enemy.accuracy >= 0.9: enemy_type = "Hunter " + enemy_type
		if enemy.health >= 5.0: enemy_type = "Armored " + enemy_type
		if enemy_type == "Ship": enemy_type = "Mini " + enemy_type

		prnt("Encountered " + enemy_type)
