extends Area2D

var count = 0
var body_to_rotate: Node2D = null  # Store the character reference
var rotation_speed = 5.0  # Speed of rotation in radians per second
var rotation_time = 2.2  # Time in seconds to complete the rotation
var rotation_timer = 0  # Timer to control rotation duration
var spiral_factor = 1.7
@onready var black_hole_sound = $black_hole_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += 360 * delta / 20  # Rotates the black hole sprite
	
	# If a character is rotating around the black hole, apply the rotation
	if body_to_rotate != null:
		rotate_around_point(body_to_rotate, position, 300, rotation_speed, delta, spiral_factor)
		rotation_timer += delta
		# Set the transparency factor
		var transparent_factor = 0.5
		# Get current level number
		var current_level = self.get_parent().name
		var level_number = int(current_level.substr(5, current_level.length() - 5)) # '5' is the index after 'level'
		# Update the transparency using modulate.a (alpha value)
		var new_alpha = body_to_rotate.modulate.a - (delta * transparent_factor)
		body_to_rotate.modulate.a = clamp(new_alpha, 0, 1)  # Ensure alpha stays between 0 (fully transparent) and 1 (fully opaque)
		# After rotating for the set time, change the scene
		var level_string = "res://levels/level_"+str(level_number+1)+".tscn"
		if rotation_timer >= rotation_time:
			get_tree().change_scene_to_file(level_string)

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
	# Only trigger the rotation once
	
	if body.name == "player":
		count += 1
		black_hole_sound.play()
		body.velocity.x = 0
		body.velocity.y = 0
		body_to_rotate = body  # trigger the character to rotate
		rotation_timer = 0.0  # Reset the rotation timer