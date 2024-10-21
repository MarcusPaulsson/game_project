extends Node2D  # Or use Sprite, CanvasItem, or a node that supports transparency

var avar = 1.0  # Example variable that controls visibility
var pulse_speed = 0.7  # Speed of the pulse effect
var pulse_direction = 1.0  # Determines if visibility is increasing or decreasing
var can_pulse = true  # Control if pulsing is allowed
var initial_visibility = 0.0  # Start from fully transparent (0)
var max_visibility = 1.0  # Maximum visibility (1.0 for full opacity)
var pulse_range = 1.0  # Range for pulsing from 0 to 1
@onready var player_ref = $"../../player"  # Reference to the player script
@onready var level_ref = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_visibility = modulate.a  # Set initial visibility to current alpha
	modulate.a = 0.0  # Make the node initially fully transparent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check the player's activity status (move_timeout)
	if level_ref.name == "how_to_play":
		modulate.a = 255
		return
	
	if player_ref.move_timeout == false:  # Player is inactive
		can_pulse = true  # Enable pulsing
	else:  # Player is active
		can_pulse = false  # Disable pulsing
		modulate.a = 0.0  # Set the node to fully transparent when active

	# Pulse the visibility of the node if pulsing is enabled
	if can_pulse:
		_pulse_visibility(delta)

# Function to handle the pulsing visibility effect
func _pulse_visibility(delta: float) -> void:
	
	# Get the current modulation color
	var modulate_color = modulate
	# Adjust the alpha value to create a fade effect between 0 and 1
	modulate_color.a += pulse_direction * pulse_speed * delta * avar * pulse_range
	
	# Ensure the alpha stays within the bounds of 0 (fully transparent) and 1 (fully opaque)
	if modulate_color.a > 1.0:
		modulate_color.a = 1.0
		pulse_direction = -1.0  # Reverse direction to start fading out
	elif modulate_color.a < 0.0:
		modulate_color.a = 0.0
		pulse_direction = 1.0  # Reverse direction to start brightening

	# Apply the new modulation alpha back to the object
	
	modulate.a = modulate_color.a  # No need to clamp since we're already ensuring bounds
