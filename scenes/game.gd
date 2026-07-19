extends Node3D
class_name Game


@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var console: RichTextLabel = $Ship/console/SubViewport/RichTextLabel
@onready var ship: Ship = $Ship

var enemy: Enemy
var enemy_attack := Timer.new()


func _ready() -> void:
	Config.config_updated.connect(_on_config_updated)
	_on_config_updated()
	enemy_attack.autostart = true
	enemy_attack.timeout.connect(on_enemy_attack)
	add_child(enemy_attack)


func _on_config_updated() -> void:
	world_environment.environment.ambient_light_energy = 0.1 * Config.get_value("graphics", "brightness", 1.0)


func on_enemy_attack() -> void:
	if enemy:
		if enemy.hit():
			ship.prnt("GOT HIT BY THE ENEMY!")
			ship.systems.pick_random().take_damage(enemy.damage_mult)
		else:
			ship.prnt("an enemy shot missed you!")


func prnt(line: String) -> void:
	console.add_text("\n" + line)


func next() -> void:
	if randi_range(0, 10) == 0:
		enemy = null
		prnt("Only Rocks displayed on Radar")
	else:
		enemy = Enemy.new()
		enemy_attack.wait_time = enemy.attack_speed
		var enemy_type := "Ship"

		if enemy.damage_mult >= 2.0 || enemy.attack_speed < 3: enemy_type = "Fighter " + enemy_type
		if enemy.accuracy >= 0.9: enemy_type = "Hunter " + enemy_type
		if enemy.health >= 5.0: enemy_type = "Armored " + enemy_type
		if enemy_type == "Ship": enemy_type = "Mini " + enemy_type

		prnt("Encountered " + enemy_type)
