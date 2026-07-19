extends RigidBody3D
class_name PowerCell


@onready var player: Player = %Player

var powering : Node


func get_input_info() -> String:
	return "[LMB] Install Power Cell\n[RMB] Drop Power Cell"


func get_interact_info() -> String:
	return "[E] Pick-Up Power Cell"


func interact() -> void:
	player.drop_item()
	freeze = true
	if powering: powering.remove_power_cell()
	player.hand.remote_path = player.hand.get_path_to(self)


func use() -> void:
	if player.interact_ray.is_colliding():
		var collider: CollisionObject3D = player.interact_ray.get_collider()
		if collider.has_method("install_power_cell"):
			if !collider.is_powered():
				player.hand.remote_path = ""
				collider.call_deferred("install_power_cell", self)


func on_drop() -> void:
	freeze = false
