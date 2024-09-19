extends Control

var profiles_config = ConfigFile.new()
@onready var container = $MarginContainer/VBoxContainer

func _ready() -> void:
	# Load profiles from the config file
	var err = profiles_config.load("res://config_folder/profiles.cfg")
	
	# Check if the file was loaded correctly
	if err != OK:
		print("Error loading config file")
		return
	
	# Get the profiles section
	var profiles = profiles_config.get_section_keys("profiles")
	
	# Loop through profiles and create MenuButtons
	for profile in profiles:
		# Get both the name and level for the profile
		var profile_data = profiles_config.get_value("profiles", profile)
		var profile_name = profile_data["name"]
		var profile_level = profile_data["level"]
		
		# Create a new MenuButton for the profile
		var menu_button = MenuButton.new()
		menu_button.text = profile_name + " - Level: " + str(profile_level)  # Add level to the button text
		
		# Connect the pressed signal using a lambda to pass profile_level
		menu_button.connect("pressed", Callable(self, "_on_menu_button_pressed").bind(profile_level))
		
		# Add the MenuButton to the container
		container.add_child(menu_button)

# Function that is called when a MenuButton is pressed
func _on_menu_button_pressed(profile_level: int) -> void:
	# Construct the level scene string based on the profile's level
	var level_scene = "res://levels/level_" + str(profile_level) + ".tscn"
	
	# Change to the appropriate level scene
	get_tree().change_scene_to_file(level_scene)
	print("Loading level: ", level_scene)
