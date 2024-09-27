extends Control

var GAME_STARTED = false

# Debug variables
var DEBUG = false
var DEBUG_level = 2

@onready var name_dialog = $AcceptDialog  # Assuming NameDialog is a WindowDialog or AcceptDialog in the scene
@onready var name_input = $AcceptDialog/LineEdit  # The input field inside the dialog for entering the name
var config = load("res://read_write_config.gd").new()
var profiles_config = ConfigFile.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DEBUG:
		get_tree().change_scene_to_file("res://levels/level_"+str(DEBUG_level)+".tscn")
	var err = profiles_config.load("user://config_folder/profiles.cfg")
	name_dialog["visible"] = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function triggered when the 'Start Game' button is pressed
func _on_start_game_pressed() -> void:
	# Show the name dialog popup for entering the player's name
	name_dialog.popup_centered()

# Function triggered when the 'Load Game' button is pressed
func _on_load_game_pressed() -> void:
	GAME_STARTED = true
	get_tree().change_scene_to_file("res://menu_folder/load_menu.tscn")
	print("Pressed load game")

# Function triggered when the 'Leaderboard' button is pressed
func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_folder/leaderboard_menu.tscn")

# Function triggered when the 'Settings' button is pressed
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_folder/settings_menu.tscn")
	print("Pressed Setting")

# Function triggered when the 'How to Play' button is pressed
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_how_to_play.tscn")
	print("pressed how to play")

# Function triggered when the 'Exit' button is pressed
func _on_exit_pressed() -> void:
	print("pressed exit")
	# Optionally save game state before exiting
	get_tree().quit()



func _on_accept_dialog_confirmed() -> void:
	name_dialog["visible"] = true
	var player_name = name_input.text  # Get the player's name from the input field
	if player_name.strip_edges() == "":
		print("Please enter a valid name")
		return

	# Here, you can save the player name or initialize it for the game
	print("Starting game with player: " + player_name)
	config.save_local_data(player_name,-1,-1,-1)
	var current_level = "level_1"
	var current_time = 0.0
	update_player_level_progress(player_name, current_level, current_time)
	
	# Proceed to the game scene after the player has entered a name
	GAME_STARTED = true
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	
	
func update_player_level_progress(profile: String, level: String, time_spent: float) -> void:
	# Check if the profile exists in the config file
	var profile_data = profiles_config.get_value("profiles", profile, null)
	
	
	profile_data = {
			"name": profile,
			"levels": {}  # Start with an empty levels dictionary
		}
	
	# Save the updated profile data back to the config
	profiles_config.set_value("profiles", profile, profile_data)
	# Save the updated config file
	var err = profiles_config.save("user://config_folder/profiles.cfg")
	if err != OK:
		print("Error saving profiles config file!")
	else:
		print("Profile updated or created successfully.")
