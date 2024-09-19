extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_on_toggled(toggled_on: bool) -> void:
	var config = ConfigFile.new()
	var err = config.load("res://config_folder/settings.cfg")
	if err == OK:
		# Read the values from the config file
		config.set_value("audio", "audio_ON", toggled_on)
		config.save("res://config_folder/settings.cfg")
		var music_ON = config.get_value("audio","audio_ON")
		print(music_ON)
