extends Node2D  # Or use Sprite, CanvasItem, or a node that supports transparency

var avar = 1.0  # Example variable that controls visibility
var pulse_speed = 2.0  # Speed of the pulse effect
var pulse_direction = 1.0  # Determines if visibility is increasing or decreasing
var can_pulse = true  # Control if pulsing is allowed
var initial_visibility = 0.0  # Start from fully transparent (0)
var max_visibility = 255.0  # Maximum visibility (255 for full opacity)
var pulse_range = 255.0  # Range for pulsing from 0 to 255

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_visibility = modulate.a  # Set initial visibility to fully transparent (0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_pulse:
		_pulse_visibility(delta)

# Function to handle the pulsing visibility effect
func _pulse_visibility(delta: float) -> void:
	# Get the current modulation color
	var modulate_color = modulate
	# Adjust the alpha value to create a fade effect between 0 and 255
	modulate_color.a += pulse_direction * pulse_speed * delta * avar * pulse_range
	
	# Ensure the alpha stays within the bounds of 0 (fully transparent) and 255 (fully opaque)
	if modulate_color.a > 255.0:
		modulate_color.a = 255.0
		pulse_direction = -1.0  # Reverse direction to start fading out
	elif modulate_color.a < 0.0:
		modulate_color.a = 0.0
		pulse_direction = 1.0  # Reverse direction to start brightening

	# Apply the new modulation alpha back to the object
	modulate.a = int(clamp(modulate_color.a, 0, 255))  # Clamp to ensure it stays within 0 and 255

	# Debugging: Print the current alpha to ensure it's changing
	print(modulate.a)
