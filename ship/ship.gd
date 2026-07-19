extends RigidBody3D
class_name Ship


@onready var optics_vp: SubViewport = $optics/SubViewport
@onready var nav_progress: ProgressBar = $nav/SubViewport/HBoxContainer/ProgressBar
@onready var nav_label: Label = $nav/SubViewport/HBoxContainer/Label
@onready var nav_screen: Tech = $"../interior/objects/nav_screen"
@onready var player: Player = %Player
@onready var game: Game = $".."

var ftl_ready := false

func _physics_process(delta: float) -> void:
	if nav_screen.is_powered():
		if !game.enemy:
			nav_progress.value = 100.0

		if nav_progress.value < 100.0:
			ftl_ready = false
			nav_progress.value = nav_progress.value + delta * randf_range(0.01, 1)
			nav_label.text = "Calibrating Engines to\nnext FTL position"
		else:
			if !ftl_ready: game.prnt("Ready to Flight")
			ftl_ready = true
			nav_label.text = "Ready to Go\nFaster Than Light"


func tp() -> void:
	player.tp_animation()
	game.next()
	await get_tree().create_timer(1).timeout
	nav_progress.value = 0


func next_camera() -> void:
	var cameras: Array[Camera3D] = []
	for cam in optics_vp.get_children():
		if cam is Camera3D: cameras.append(cam)

	if cameras.is_empty(): return

	cameras[(cameras.find(optics_vp.get_camera_3d()) + 1) % cameras.size()].make_current()
