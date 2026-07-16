extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action("pause") && visible:
		get_viewport().set_input_as_handled()
		hide()


func exit() -> void:
	get_tree().change_scene_to_file("res://menus/main.tscn")
