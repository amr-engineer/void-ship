extends Node


func start() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func quit() -> void:
	get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		quit()


func _ready() -> void:
	$Version.text = "v" + str(ProjectSettings.get_setting("application/config/version"))
