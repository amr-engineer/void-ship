extends Node


const SAVE_PATH := "user://config.ini"

var options := ConfigFile.new()


func _ready() -> void:
	options.load(SAVE_PATH)
	
	DisplayServer.window_set_vsync_mode(clamp(options.get_value("graphics", "vsync", 2), 0, 3))
	
	AudioServer.set_bus_volume_db(0, options.get_value("audio", "master", 0.0))
	AudioServer.set_bus_volume_db(1, options.get_value("audio", "sfx", 0.0))
	AudioServer.set_bus_volume_db(2, options.get_value("audio", "background", 0.0))
	AudioServer.set_bus_volume_db(3, options.get_value("audio", "ambient", 0.0))
	AudioServer.set_bus_volume_db(4, options.get_value("audio", "music", 0.0))


func save() -> Error:
	return options.save(SAVE_PATH)
