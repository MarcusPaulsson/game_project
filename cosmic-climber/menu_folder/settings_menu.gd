extends Control
@onready var volume_toggle = $"MarginContainer/VBoxContainer/Volume on"
var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the configuration file
	var err = config.load("res://config_folder/local.cfg")
	
	if err == OK:
		# Read the 'volume_ON' value from the 'local' section or default to false if not found
		volume_toggle.button_pressed = config.get_value("local", "volume_ON", false)
	else:
		print("Error loading config file: ", err)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function to handle volume toggle
func _on_volume_on_toggled(toggled_on: bool) -> void:
	# Set the 'volume_ON' value in the 'local' section when toggled
	config.set_value("local", "volume_ON", toggled_on)
	
	# Save the configuration to the file
	var save_err = config.save("res://config_folder/local.cfg")
	
	if save_err == OK:
		var volume_ON = config.get_value("local", "volume_ON")
		print("Volume toggled:", volume_ON)
	else:
		print("Error saving config file: ", save_err)

# Function to handle button press
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
