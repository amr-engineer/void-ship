extends RigidBody3D
class_name NoFire


@onready var player: Player = %Player


func get_input_info() -> String:
	return "[LMB] Fix a SubSystem\n[RMB] Drop Fire Extinguisher"


func get_interact_info() -> String:
	return "[E] Pick-Up Fire Extinguisher"


func interact() -> void:
	player.drop_item()
	freeze = true
	player.hand.remote_path = player.hand.get_path_to(self)


func use() -> void:
	if player.interact_ray.is_colliding():
		var collider: CollisionObject3D = player.interact_ray.get_collider()
		if collider.has_method("fix"): collider.fix()


func on_drop() -> void:
	freeze = false
