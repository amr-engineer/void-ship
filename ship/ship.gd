extends RigidBody3D
class_name Ship


@onready var optics_vp: SubViewport = $optics/SubViewport


func next_camera() -> void:
	var cameras: Array[Camera3D] = []
	for cam in optics_vp.get_children():
		if cam is Camera3D: cameras.append(cam)

	if cameras.is_empty(): return

	cameras[(cameras.find(optics_vp.get_camera_3d()) + 1) % cameras.size()].make_current()
