extends Label

var profiles_config = ConfigFile.new()
var current_player_name = ""  # This will be set from the local data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the player name from the local config file
	var config = load("res://read_write_config.gd").new()
	current_player_name = config.load_local_data()[0]  # Assuming the player's name is the first item in local data

	if current_player_name.strip_edges() == "":
		print("No valid player name found.")
		return

	# Load and print the current player's score
	load_and_print_current_player_score()

# Function to load profiles and print out the current player's score
func load_and_print_current_player_score() -> void:
	# Load profiles from the config file
	var err = profiles_config.load("user://config_folder/profiles.cfg")
	
	# Check if the file was loaded correctly
	if err != OK:
		print("Error loading profiles.cfg")
		return
	
	# Get the profiles section
	var profiles = profiles_config.get_section_keys("profiles")
	
	# Loop through profiles to find the current player's profile
	for profile in profiles:
		var profile_data = profiles_config.get_value("profiles", profile)
		var profile_name = profile_data["name"]
		
		if profile_name == current_player_name:
			var levels = profile_data["levels"]
			var level_count = levels.size()  # Number of levels completed
			var total_time_spent = 0.0

			# Sum the time spent on each level
			for level in levels:
				total_time_spent += levels[level]["time_spent"]
			
			# Set the label's text to display the current player's score
			text = "Total Time: " + str(int(total_time_spent)) +" s"
			return  # Exit once the current player's profile is found

	# If no profile matches the current player, handle it appropriately
	text = "Player profile not found"
