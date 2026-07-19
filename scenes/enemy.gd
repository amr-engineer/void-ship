extends Node
class_name Enemy


var health : float = randf_range(0.5, 10.0)
var damage_mult : float = randf_range(0.5, 3)
var attack_speed : int = randi_range(1, 10)
var accuracy : float = randf_range(0.1, 1)


func hit() -> bool:
	return randf_range(0, 2 / accuracy) < 1

func take_damage(minimum: float = 0.05) -> void:
	health -= randf_range(minimum, 1.0)
