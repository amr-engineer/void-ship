extends CharacterBody3D
class_name Player


@export var camera: Camera3D

@onready var head: RemoteTransform3D = $head
@onready var hand: RemoteTransform3D = $head/hand
@onready var pause_menu: CanvasLayer = $UI/PauseMenu
@onready var interact_ray: RayCast3D = $head/interact
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_screen: ColorRect = $UI/death_screen


const LONG_PRESS_DURATION = 200 # in ms
const SPEED = 4.0
const SPRINT_MULT := 1.5
const JUMP_VELOCITY = 3.5
const MASS = 1
const EARLY_JUMP_TIMEOUT = 0.1 # in sec
const LAZY_JUMP_TIMEOUT = 0.15 # in sec

var speed_mult := 10.0 # sprint multiplier, 1 for walking speed
var early_jumper := 0.0
var lazy_jumper := 0.0
var sprint_start_msec := 0
var is_sprinting := false

var time_elapsed: float = 0.0


func exit() -> void:
	get_tree().change_scene_to_file("res://menus/main.tscn")


func set_cam(cam: Camera3D = camera) -> void:
	if cam:
		head.remote_path = cam.get_path()
		camera = cam


func drop_item() -> void:
	var item_in_hand := hand.get_node_or_null(hand.remote_path)
	if item_in_hand && item_in_hand.has_method("on_drop"): item_in_hand.on_drop()
	hand.remote_path = ""


func tp_animation() -> void:
	animation_player.play("tp")


func format_time(time: float) -> String:
	@warning_ignore("integer_division")
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	var milliseconds: int = int((time - int(time)) * 100)
	
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


func on_pause_state_changed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pause_menu.visible else Input.MOUSE_MODE_CAPTURED
	Engine.time_scale = float(!pause_menu.visible)


func _on_config_updated() -> void:
	$SubViewportContainer.stretch_shrink = ceili(1 / Config.options.get_value("graphics", "resolution", 1.0))


func _ready() -> void:
	set_cam()
	pause_menu.hide()
	pause_menu.visibility_changed.connect(on_pause_state_changed)
	on_pause_state_changed()

	Config.config_updated.connect(_on_config_updated)
	_on_config_updated()


func _input(event: InputEvent) -> void:
	if event.is_action("pause") && !pause_menu.visible:
		get_viewport().set_input_as_handled()
		pause_menu.show()
	if event.is_action_pressed("debug"):
		$UI/debug.visible = !$UI/debug.visible

	if event.is_action_pressed("sprint"):
		sprint_start_msec = Time.get_ticks_msec()
		is_sprinting = !is_sprinting
	if event.is_action_released("sprint"):
		if Time.get_ticks_msec() - sprint_start_msec > LONG_PRESS_DURATION:
			is_sprinting = false

	if event.is_action_pressed("interact"):
		if interact_ray.is_colliding():
			var collider = interact_ray.get_collider()
			if collider.has_method("interact"): collider.interact()

	if event.is_action_pressed("use"):
		var item_in_hand := hand.get_node_or_null(hand.remote_path)
		if item_in_hand && item_in_hand.has_method("use"): item_in_hand.use()
	if event.is_action_pressed("drop"):
		drop_item()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && !pause_menu.visible:
		head.rotation.x -= event.relative.y * 0.01
		rotation.y -= event.relative.x * 0.01
		head.rotation.x = min(1.57, head.rotation.x)
		head.rotation.x = max(-1.57, head.rotation.x)


func _process(delta: float) -> void:
	var txt = """FPS: %s
	(%.2f, %.2f, %.2f)
	%.2f, %.2f""" % [
		Engine.get_frames_per_second(),
		position.x, position.y, position.z,
		rotation_degrees.y, head.rotation_degrees.x
		]
	$UI/debug.text = txt

	$UI/info.text = ""
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider.has_method("get_interact_info"): $UI/info.text += str(collider.get_interact_info())

	var item_in_hand := hand.get_node_or_null(hand.remote_path)
	if item_in_hand && item_in_hand.has_method("get_input_info"): $UI/info.text += "\n" + str(item_in_hand.get_input_info())
	
	time_elapsed += delta
	$UI/time.text = format_time(time_elapsed)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		lazy_jumper = LAZY_JUMP_TIMEOUT
		if early_jumper > 0:
			lazy_jumper = 0.0
			early_jumper = 0.0
			velocity.y = JUMP_VELOCITY
	else:
		lazy_jumper -= delta
		early_jumper -= delta
		velocity += MASS * get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or lazy_jumper > 0:
			lazy_jumper = 0.0
			velocity.y = JUMP_VELOCITY
		else:
			early_jumper = EARLY_JUMP_TIMEOUT

	speed_mult = SPRINT_MULT * float(is_sprinting) + 1.0

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_mult
		velocity.z = direction.z * SPEED * speed_mult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
