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
@onready var coll_area = $Area2D
@onready var player = $"../player"  # Reference to the player

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
		self.position = player.get_node("Marker2D").global_position + Vector2(player.current_dir * 19, -15)
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
	# Drop item if currently holding it, but only if the player can process box interaction
	if Input.is_action_just_pressed("ui_pick_or_throw") and player.can_process_box_interaction:
		player.can_process_box_interaction = false  # Block further interaction for a short time
		player.reset_box_interaction_timeout()  # Call the player's method to reset the timeout
		
		var bodies = $pick_up_area.get_overlapping_bodies()
		var box_over_laps = coll_area.get_overlapping_bodies()
		
		# Check if the player is holding an item
		if picked and not player.canPick and box_over_laps.size() == 0:
			var player_velocity = player.velocity  # Assuming player has a velocity property
			self.position = player.get_node("Marker2D").global_position + Vector2(player.current_dir * 19, -15)
			
			# Set initial throw direction based on player's facing direction
			var throw_direction = player_velocity * 1.5  # Default throw vector
			# Apply player's velocity to the throw for added momentum
			self.linear_velocity = throw_direction
			# Allow player to pick up items again
			player.canPick = true
			picked = false  # Release the item
			return
		
		else:
			player.can_process_box_interaction = true
			# Check if the player can pick up an item
			for body in bodies:
				if body.name == "player" and player.canPick:
					picked = true
					self.rotation_degrees = 0
					pick_up_box_sound.play()
					player.canPick = false
					# Stop pulsing permanently once picked up
					can_pulse = false
					box_type.modulate = initial_color  # Reset color to the original
					return
