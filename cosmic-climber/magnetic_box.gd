extends Node2D

@onready var mag_field = $Area2D



# Attraction strength factor (adjustable for stronger or weaker pull)
var attraction_strength = 8000.0
# Maximum velocity cap
var max_velocity = 500.0
# Threshold to consider the object "close enough" to the magnet
var stop_threshold = 20.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get all objects inside the magnetic field area
	var objects_in_gravity_field = mag_field.get_overlapping_bodies()
	
	# Process each object
	
	
	for object in objects_in_gravity_field:
		
		if object.name.substr(0, 5) == "metal" and object.has_method("set_linear_velocity"):
			# Calculate the distance and direction to the magnet (self)
			var distance = self.global_position.distance_to(object.global_position)
			var direction_to_magnet = (self.global_position - object.global_position).normalized()
			print(direction_to_magnet)
			# Only apply magnetic force if the object is outside the stop threshold
			if distance > stop_threshold:
				# Calculate the magnetic force (stronger when farther, weaker when close)
				var magnetic_force = direction_to_magnet * attraction_strength 
				
				# Apply damping to reduce velocity over time
				var damping = 0.2
				object.linear_velocity *= damping
				
				# Apply magnetic force to the velocity
				object.linear_velocity = object.linear_velocity * damping + magnetic_force * delta
				
				# Cap the velocity to prevent it from getting too large
				if object.linear_velocity.length() > max_velocity:
					object.linear_velocity = object.linear_velocity.normalized() * max_velocity
			else:
				# Stop the object when it is close enough to the magnet
				object.linear_velocity = Vector2.ZERO
