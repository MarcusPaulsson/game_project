var global_config = ConfigFile.new() 

# Function to load global variables from the .cfg file
func load_local_data():
	var err = global_config.load("res://config_folder/local.cfg")
	if err != OK:
		print("Error loading config file")
		return
	
	# Retrieve global variables
	var current_player = global_config.get_value("local", "current_player")
	var total_time_played = global_config.get_value("local", "total_time_played")
	var sound_volume = global_config.get_value("local", "sound_volume")
	var high_score = global_config.get_value("local", "high_score")
	
	# Use these variables throughout the game
	print("Current Level:", current_player)
	print("Total Time Played:", total_time_played)
	print("Sound Volume:", sound_volume)
	print("High Score:", high_score)
	# Store them in your game's global state if needed
	return [current_player, total_time_played, sound_volume, high_score]

# Function to save global variables to the .cfg file
func save_local_data(current_player: String, total_time_played: int, sound_volume: float, high_score: int):
	global_config.load("res://config_folder/local.cfg")
	# Save global variables
	global_config.set_value("local", "current_player", current_player)
	if total_time_played>=0:
		global_config.set_value("local", "total_time_played", total_time_played)
	if sound_volume>=0:
		global_config.set_value("local", "sound_volume", sound_volume)
	if high_score>=0:
		global_config.set_value("local", "high_score", high_score)
	
	# Save the config file
	var err = global_config.save("res://config_folder/local.cfg")
	if err != OK:
		print("Error saving config file")