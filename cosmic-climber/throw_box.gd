# Script for all kinds of pick-up boxes!!!
extends RigidBody2D

@onready var box_type = $ObjCrate002
var picked = false
var held_object = null
var in_mag_field = false
var pulse_speed = 2.0  # Speed of the fade animation
var pulse_color_range = 0.2  # The range the color will oscillate within (from original to darker)
var pulse_direction = 1.0  # Determines if the color is brightening or darkening
var can_pulse = true  # Control if the pulsing effect should continue

# Reference to the collision shape node
var collision_shape
const metal_type = "<CompressedTexture2D#-9223371999290587739>"
@onready var pick_up_box_sound = $pick_up_box
var initial_position
var initial_color  # To store the initial color of the object
var used_cells 
var distance = INF

func _ready() -> void:
	# Get reference to the collision shape node
	collision_shape = $CollisionShape2D
	# Store the object's initial position when it spawns
	initial_position = self.global_position
	# Store the initial modulation color (default is white, which means no color change)
	initial_color = box_type.modulate

func _process(delta: float) -> void:
	self.gravity_scale = 1.0
	
	if picked:
		# Make the item follow the player's position
		self.rotation_degrees = 0.0
		self.position = get_node("../player/Marker2D").global_position + Vector2(get_node("../player").current_dir * 19, 10)
		# Disable the collision shape when picked up
		collision_shape.disabled = true
		# Stop pulsing once picked
		can_pulse = false
		box_type.modulate = initial_color  # Set to the original color
	else:
		collision_shape.disabled = false
		
		# Pulse the box if it hasn't been picked up yet and can still pulse
		if not picked and can_pulse:
			_fade_box(delta)

func _fade_box(delta: float) -> void:
	# Get the current modulation color
	var modulate_color = box_type.modulate
	# Adjust the color value to create a fade effect between the initial color and a darker shade
	modulate_color.r += pulse_direction * pulse_speed * delta * pulse_color_range
	modulate_color.g += pulse_direction * pulse_speed * delta * pulse_color_range
	modulate_color.b += pulse_direction * pulse_speed * delta * pulse_color_range
	
	# Ensure the color stays within the bounds of slightly darker and the original
	if modulate_color.r > initial_color.r:
		modulate_color = initial_color
		pulse_direction = -1.0  # Reverse direction to start darkening
	elif modulate_color.r < initial_color.r - pulse_color_range:
		modulate_color = initial_color.darkened(pulse_color_range)  # Make it slightly darker
		pulse_direction = 1.0  # Reverse direction to start brightening
	
	# Apply the new modulation color back to the object
	box_type.modulate = modulate_color

func _input(event):
	# Drop item if currently holding it
	if Input.is_action_just_pressed("ui_pick_or_throw"):
		
		# Check if the player is holding an item
		if picked and not get_node("../player").canPick:
			var player = get_node("../player")
			var player_velocity = player.velocity  # Assuming player has a velocity property
			self.position = get_node("../player/Marker2D").global_position + Vector2(player.current_dir * 19, 10)
			
			# Set initial throw direction based on player's facing direction
			var throw_direction = player_velocity * 1.5  # Default throw vector
			# Apply player's velocity to the throw for added momentum
			self.linear_velocity = throw_direction
			# Allow player to pick up items again
			player.canPick = true
			picked = false  # Release the item
			return
			
		else:
			# Check if the player can pick up an item
			var bodies = $pick_up_area.get_overlapping_bodies()
			for body in bodies:
				if body.name == "player" and get_node("../player").canPick:
					picked = true
					self.rotation_degrees = 0
					pick_up_box_sound.play()
					get_node("../player").canPick = false
					# Stop pulsing permanently once picked up
					can_pulse = false
					box_type.modulate = initial_color  # Reset color to the original
					break
