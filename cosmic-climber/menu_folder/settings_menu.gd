extends Control
@onready var volume_toggle = $"MarginContainer/VBoxContainer/Volume on"
var config = ConfigFile.new()
@onready var volume_controller = $"../AudioStreamPlayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the configuration file
	var err = config.load("res://local_config/local.cfg")
	
	if err == OK:
		# Read the 'volume_ON' value from the 'local' section or default to false if not found
		volume_toggle.button_pressed = config.get_value("local", "volume_ON", false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function to handle volume toggle
func _on_volume_on_toggled(toggled_on: bool) -> void:
	# Set the 'volume_ON' value in the 'local' section when toggled
	config.set_value("local", "volume_ON", toggled_on)
	
	# Save the configuration to the file
	var save_err = config.save("res://local_config/local.cfg")
	
	
	if save_err == OK:
		var volume_ON = config.get_value("local", "volume_ON")
		if !volume_ON:
			volume_controller.stop()
			
		else:
			volume_controller.play()
			volume_controller.autoplay = true
			

# Function to handle button press
func _on_button_pressed() -> void:
	visible = false
	#get_tree().change_scene_to_file("res://menu_folder/main_menu.tscn")
