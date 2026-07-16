extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		hide()


func _ready() -> void:
	%sensitivity.value = Config.options.get_value("general", "sensitivity", 1.0)

	%resolution.value = Config.options.get_value("graphics", "resolution", 1.0)
	%vsync.selected = Config.options.get_value("graphics", "vsync", 2)

	%master_audio.value = Config.options.get_value("audio", "master", 0.0)
	%sfx_audio.value = Config.options.get_value("audio", "sfx", 0.0)
	%ambient_audio.value = Config.options.get_value("audio", "ambient", 0.0)
	%music_audio.value = Config.options.get_value("audio", "music", 0.0)


func save() -> void:
	print("Save options error code: ", Config.save())


func _on_sensitivity_value_changed(value: float) -> void:
	Config.options.set_value("general", "sensitivity", value)


func _on_resolution_value_changed(value: float) -> void:
	Config.options.set_value("graphics", "resolution", value)


func _on_vsync_item_selected(index: int) -> void:
	DisplayServer.window_set_vsync_mode(clamp(index, 0, 3))
	Config.options.set_value("graphics", "vsync", index)


func _on_master_audio_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	Config.options.set_value("audio", "master", value)


func _on_sfx_audio_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	Config.options.set_value("audio", "sfx", value)


func _on_ambient_audio_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3, value)
	Config.options.set_value("audio", "ambient", value)


func _on_music_audio_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(4, value)
	Config.options.set_value("audio", "music", value)
