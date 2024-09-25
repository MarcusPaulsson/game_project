extends Node2D

@onready var mag_field = $Area2D

var objects_in_gravity_field = []

# Attraction strength factor (adjustable for stronger or weaker pull)
var attraction_strength = 24000.0
# Maximum velocity cap
var max_velocity = 500.0
# Threshold to consider the object "close enough" to the magnet
var stop_threshold = 20.0

func _process(delta: float) -> void:
	# Get all objects inside the magnetic field area
	objects_in_gravity_field = mag_field.get_overlapping_bodies()
	
	for object in objects_in_gravity_field:
		if object.name.substr(0, 5) == "metal":
			# Ensure the object is a RigidBody2D
			if object is RigidBody2D:
				# Calculate the vector from the object to the magnet
				var direction = self.global_position - object.global_position
				
				var distance = direction.length()
				
				# Check if the object is close enough
				if distance > stop_threshold:
					# Normalize the direction vector
					direction = direction.normalized()
					
					# Calculate the force magnitude using inverse-square law
					var force_magnitude = attraction_strength / (distance * distance)
					# Apply the impulse at the object's center of mass
					object.apply_central_force(direction*force_magnitude)
					object.gravity_scale = object.gravity_scale/distance
					# Cap the object's velocity
					if object.linear_velocity.length() > max_velocity:
						object.linear_velocity = object.linear_velocity.normalized() * max_velocity
