extends RigidBody3D
class_name Ship


@onready var optics_vp: SubViewport = $optics/SubViewport
@onready var nav_progress: ProgressBar = $nav/SubViewport/HBoxContainer/ProgressBar
@onready var nav_label: Label = $nav/SubViewport/HBoxContainer/Label
@onready var nav_screen: Tech = $"../interior/objects/nav_screen"
@onready var gun_progress: ProgressBar = $gun/SubViewport/HBoxContainer/ProgressBar
@onready var gun_label: Label = $gun/SubViewport/HBoxContainer/Label
@onready var gun_screen: Tech = $"../interior/objects/gun_screen"

@onready var player: Player = %Player
@onready var game: Game = $".."

@onready var systems: Array[Tech] = [
	$"../interior/objects/optics_screen",
	$"../interior/objects/nav_screen"
]

var health: float = 5.0
var ftl_ready := false
var shot_ready := false


func _physics_process(delta: float) -> void:
	if health <= 0.0:
		player.pause_menu.show()
		player.death_screen.show()
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

	if gun_progress.value < 100.0:
		shot_ready = false
		if gun_screen.is_powered():
			gun_progress.value = gun_progress.value + delta * randi_range(1, 5)
			gun_label.text = "Autoloading..."
	else:
		shot_ready = true
		if gun_screen.is_powered():
			gun_label.text = "FIRE IN THE HOLE"
			if game.enemy: shot()


func prnt(line: String) -> void:
	$console/SubViewport/RichTextLabel.add_text("\n" + line)


func tp() -> void:
	player.tp_animation()
	game.next()
	await get_tree().create_timer(1).timeout
	nav_progress.value = 0


func shot() -> void:
	gun_progress.value = 0
	if game.enemy:
		game.enemy.take_damage(0.5)
		prnt("Enemy got damaged")
	else:
		prnt("Your are shooting on stars")


func next_camera() -> void:
	var cameras: Array[Camera3D] = []
	for cam in optics_vp.get_children():
		if cam is Camera3D: cameras.append(cam)

	if cameras.is_empty(): return

	cameras[(cameras.find(optics_vp.get_camera_3d()) + 1) % cameras.size()].make_current()
