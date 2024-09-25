extends Area2D

var count = 0
var body_to_rotate: Node2D = null  # Store the character reference
var rotation_speed = 5.0  # Speed of rotation in radians per second
var rotation_time = 2.2  # Time in seconds to complete the rotation
var rotation_timer = 0  # Timer to control rotation duration
var spiral_factor = 1.7
var profiles_config = ConfigFile.new()
var current_profile
var current_level = ""
var level_number = ""

@onready var timer_reference = $"../HUD/timer_clock"

@onready var black_hole_sound = $black_hole_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = profiles_config.load("user://config_folder/profiles.cfg")
	var config_local = load("res://read_write_config.gd").new()
	var content = config_local.load_local_data()[0]
	current_profile = content
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += 360 * delta / 20  # Rotates the black hole sprite
	
	# If a character is rotating around the black hole, apply the rotation
	if body_to_rotate != null:
		rotate_around_point(body_to_rotate, position, 300, rotation_speed, delta, spiral_factor)
		rotation_timer += delta
		# Set the transparency factor
		var transparent_factor = 0.5
		# Update the transparency using modulate.a (alpha value)
		var new_alpha = body_to_rotate.modulate.a - (delta * transparent_factor)
		body_to_rotate.modulate.a = clamp(new_alpha, 0, 1)  # Ensure alpha stays between 0 (fully transparent) and 1 (fully opaque)
		# After rotating for the set time, change the scene
		var level_string = "res://levels/level_"+str(level_number+1)+".tscn"
		if rotation_timer >= rotation_time:
			get_tree().change_scene_to_file(level_string)

# Function to update and save the player's level progress with time spent
func update_player_level_progress(profile: String, level: int, time_spent: float) -> void:
	# Get the current profile's data
	var profile_data = profiles_config.get_value("profiles", profile)
	# Get the levels data or create a new dictionary if it doesn't exist
	var levels_data = profile_data.get("levels", {})
	# Get or create the data for the current level
	var level_data = levels_data.get("level_"+str(level), {"time_spent": 0})
	# Update the time spent for the current level (you can choose whether to add or overwrite the value)
	level_data["time_spent"] = time_spent
	# Save the updated level data back to the levels dictionary
	levels_data["level_"+str(level+1)] = level_data
	profile_data["levels"] = levels_data
	
	# Save the updated profile data back to the config
	profiles_config.set_value("profiles", profile, profile_data)
	# Save the updated config file
	var err = profiles_config.save("user://config_folder/profiles.cfg")
	
	
# Function to rotate the character around a central point (e.g., the black hole)
func rotate_around_point(body: Node2D, center: Vector2, radius: float, speed: float, delta: float, spiral_factor: float) -> void:
	# Calculate the angle of rotation using the speed
	var angle = speed * delta
	# Get the current position relative to the center
	var offset = body.position - center
	# Calculate the new position by rotating the offset
	var new_offset = offset.rotated(angle)
	# Reduce the radius based on the spiral_factor
	var distance_to_center = new_offset.length() * (1.0 - spiral_factor * delta)
	# Update the offset length based on the new, reduced radius
	new_offset = new_offset.normalized() * distance_to_center
	# Set the new position based on the rotated and reduced offset
	body.position = center + new_offset
	body.rotation_degrees += 360 * delta / 1  # Rotates the black hole sprite
	# Reset velocity for smooth movement
	body.velocity = Vector2.ZERO




# When the character enters the black hole's area
func _on_body_entered(body: Node2D) -> void:
	var current_time = timer_reference.elapsed_time # Only trigger the rotation once
	if body.name == "player":
		count += 1
		black_hole_sound.play()
		body.velocity.x = 0
		body.velocity.y = 0
		body_to_rotate = body  # Trigger the character to rotate
		rotation_timer = 0.0  # Reset the rotation timer
		current_level = self.get_parent().name
		level_number = int(current_level.substr(5, current_level.length() - 5))
		# Update player's progress with time spent on the level
		update_player_level_progress(current_profile, level_number, current_time)
