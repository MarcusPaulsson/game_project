extends Control
@onready var container = $MarginContainer/VBoxContainer
var profiles_config = ConfigFile.new()
var config = load("res://read_write_config.gd").new()
func _ready() -> void:
	# Load profiles from the config file
	var err = profiles_config.load("user://config_folder/profiles.cfg")
	
	# Check if the file was loaded correctly
	if err != OK:
		return
	
	# Get the profiles section
	var profiles = profiles_config.get_section_keys("profiles")
	
	# Loop through profiles and create MenuButtons
	for profile in profiles:
		# Get the profile data
		var profile_data = profiles_config.get_value("profiles", profile)
		var profile_name = profile_data["name"]
		
		# Get the last level the player has completed
		var levels_data = profile_data.get("levels", {})
		var last_level = _get_last_level(levels_data) 
		
		# Create a new Button for the profile
		var profile_button = Button.new()
		
		# Consistently format the text using String.format()
		var button_text = "%s: Current Level %d" % [profile_name, last_level]
		profile_button.text = button_text  # Set the formatted text
		
		# Connect the pressed signal using a lambda to pass the last_level
		profile_button.connect("pressed", Callable(self, "_on_menu_button_pressed").bind(last_level, profile))

		# Add the Button to the container
		container.add_child(profile_button)


# Function to get the last completed level by the player
func _get_last_level(levels_data: Dictionary) -> int:
	var levels_keys = levels_data.keys()
	if levels_keys.size() == 0:
		return 1  # Default to level 1 if no levels found
	levels_keys.sort()  # Sort levels based on their keys
	var last_level_key = levels_keys.back()  # Get the last key (e.g., "level_3")
	var last_level_num = int(last_level_key.split("_")[1])  # Extract the level number
	
	return last_level_num

# Function that is called when a MenuButton is pressed
func _on_menu_button_pressed(profile_level: int, profile_profile: String) -> void:
	# Construct the level scene string based on the last completed level
	var level_scene = "res://levels/level_" + str(profile_level) + ".tscn"
	# Change to the appropriate level scene
	config.save_local_data(profile_profile,-1,-1,-1)
	get_tree().change_scene_to_file(level_scene)

# Function that is called when the back button is pressed
func _on_back_pressed() -> void:
	visible = false
	#get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
