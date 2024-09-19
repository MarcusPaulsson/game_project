extends Control

var profiles_config = ConfigFile.new()
@onready var container = $MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_profiles_and_print_leaderboard()

# Function to load profiles and print out the top 5 profiles (leaderboard)
func load_profiles_and_print_leaderboard() -> void:
	# Load profiles from the config file
	var err = profiles_config.load("res://config_folder/profiles.cfg")
	
	# Check if the file was loaded correctly
	if err != OK:
		print("Error loading config file")
		return
	
	# Get the profiles section
	var profiles = profiles_config.get_section_keys("profiles")
	
	# Create an array to store profile data for sorting
	var profile_list = []
	
	# Loop through profiles and store name and level in a list
	for profile in profiles:
		var profile_data = profiles_config.get_value("profiles", profile)
		var profile_name = profile_data["name"]
		var profile_level = profile_data["level"]
		
		# Add the profile data to the list
		profile_list.append({"name": profile_name, "level": profile_level})
	
	# Sort the profiles by level in descending order using a callable
	profile_list.sort_custom(Callable(self, "_sort_profiles_by_level"))
	
	# Print out the top 5 profiles
	for i in range(min(profile_list.size(), 5)):  # Ensure we only print the top 5
		var profile = profile_list[i]
		print(str(i+1) + ". " + profile["name"] + " - Level: " + str(profile["level"]))

		# Create a new label for each leaderboard entry
		var label = Label.new()
		label.text = str(i + 1) + ". " + profile["name"] + " - Level: " + str(profile["level"])
		container.add_child(label)

# Custom sorting function for sorting profiles by their level (descending order)
func _sort_profiles_by_level(a, b) -> int:
	return int(b["level"]) - int(a["level"])  # Sort by level in descending order


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
