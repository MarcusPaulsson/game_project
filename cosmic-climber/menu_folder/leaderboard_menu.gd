extends Control

var profiles_config = ConfigFile.new()
@onready var container = $MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_profiles_and_print_leaderboard()

# Function to load profiles and print out the top 5 profiles (leaderboard)
func load_profiles_and_print_leaderboard() -> void:
	# Load profiles from the config file
	var err = profiles_config.load("user://config_folder/profiles.cfg")
	
	# Check if the file was loaded correctly
	if err != OK:
		return
		
	
	# Get the profiles section
	var profiles = profiles_config.get_section_keys("profiles")
	
	# Create an array to store profile data for sorting
	var profile_list = []
	
	# Loop through profiles and store name and level progress in a list
	for profile in profiles:
		var profile_data = profiles_config.get_value("profiles", profile)
		var profile_name = profile_data["name"]
		var levels = profile_data["levels"]
		
		# Calculate the number of levels completed and the total time spent
		var level_count = levels.size()  # Number of levels completed
		var total_time_spent = 0.0
		
		# Sum the time spent on each level
		for level in levels:
			total_time_spent += levels[level]["time_spent"]
		
		# Add the profile data to the list
		profile_list.append({
			"name": profile_name, 
			"level_count": level_count, 
			"total_time_spent": total_time_spent
		})
	
	# Sort the profiles by level count in descending order, and by time spent if level count is equal
	profile_list.sort_custom(Callable(self, "_sort_profiles_by_level"))
	
	# Print out the top 5 profiles
	for i in range(min(profile_list.size(), 5)):  # Ensure we only print the top 5
		var profile = profile_list[i]
		
		# Create a new label for each leaderboard entry
		var label = Label.new()
		label.text = str(i + 1) + ". " + profile["name"] + "\t  Levels Completed: " + str(profile["level_count"]) + "\t Total Time: " + str(profile["total_time_spent"])
		container.add_child(label)

# Custom sorting function for sorting profiles by their level count and total time spent
func _sort_profiles_by_level(a, b) -> int:
	# First compare by level count (descending order)
	if int(a["level_count"]) != int(b["level_count"]):
		return int(b["level_count"]) - int(a["level_count"])
	# If level counts are equal, sort by total time spent (ascending order, less time is better)
	return float(a["total_time_spent"]) - float(b["total_time_spent"])

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
