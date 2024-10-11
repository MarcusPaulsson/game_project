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
		print("Error loading profiles file: ", err)
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
	
	# First sort by level count (descending order)
	

	
	profile_list = sort_my_profiles(profile_list)


	# Print out the top 5 profiles
	for i in range(min(profile_list.size(), 5)):  # Ensure we only print the top 5
		var profile = profile_list[i]
		
		# Create a new label for each leaderboard entry
		var label = Label.new()
		label.text = str(i + 1) + ". " + profile["name"] + "\t  Levels Completed: " + str(profile["level_count"]) + "\t Total Time: " + str(profile["total_time_spent"])
		container.add_child(label)

# Custom sorting function for sorting by level count (descending order)
func _sort_by_level_count(a, b) -> int:
	return int(b["level_count"]) - int(a["level_count"])

# Entry function to initiate the recursive sorting process
func sort_my_profiles(profile_list):
	if profile_list.size() == 0:
		return profile_list
	return _recursive_sort(profile_list)

# Recursive sorting function
func _recursive_sort(profile_list):
	if profile_list.size() <= 1:
		return profile_list

	# Choosing the pivot for partitioning
	var pivot = profile_list[0]
	var less = []
	var equal = []
	var greater = []

	# Partitioning logic based on level count primarily, then total time spent
	for profile in profile_list:
		if profile["level_count"] > pivot["level_count"]:
			greater.append(profile)
		elif profile["level_count"] < pivot["level_count"]:
			less.append(profile)
		else:
			# If levels are the same, compare by total time spent
			if profile["total_time_spent"] > pivot["total_time_spent"]:
				less.append(profile)
			elif profile["total_time_spent"] < pivot["total_time_spent"]:
				greater.append(profile)
			else:
				equal.append(profile)

	# Recursively sort the partitions
	greater = _recursive_sort(greater)
	less = _recursive_sort(less)
	
	# Combining the results
	return greater + equal + less


func _on_pressed() -> void:
	visible = false
	#get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
