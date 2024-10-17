extends Node2D

@onready var mag_field = $Area2D
@onready var audio = $AudioStreamPlayer

var objects_in_gravity_field = []
var previous_objects_in_gravity_field = []
var played_audio_for_objects = [] # Track objects that have already triggered audio

# Attraction strength factor (adjustable for stronger or weaker pull)
var attraction_strength = 18000.0
# Maximum velocity cap
var max_velocity = 500.0
# Threshold to consider the object "close enough" to the magnet
var stop_threshold = 20.0

func _process(delta: float) -> void:
	# Get all objects inside the magnetic field area
	objects_in_gravity_field = mag_field.get_overlapping_bodies()
	
	# Check for objects that have exited the field
	for object in previous_objects_in_gravity_field:
		if object not in objects_in_gravity_field and object in played_audio_for_objects:
			played_audio_for_objects.erase(object)  # Remove it from the list if it has exited
	
	# Process objects inside the magnetic field
	for object in objects_in_gravity_field:
		if object.name.substr(0, 5) == "metal":
			# Ensure the object is a RigidBody2D
			if object is RigidBody2D:
				# Calculate the vector from the object to the magnet
				var direction = self.global_position - object.global_position
				var distance = direction.length()
				
				# Play the audio for new metal objects entering the field
				if object not in played_audio_for_objects:
					audio.play()
					audio.volume_db = -15
					played_audio_for_objects.append(object)
					# Schedule to stop the audio after 1 second
					await get_tree().create_timer(0.7).timeout # cut so that unwanted sound isnt playing...
					if audio.playing:
						audio.stop()
				
				# Check if the object is close enough
				if distance > stop_threshold:
					# Normalize the direction vector
					direction = direction.normalized()
					
					# Calculate the force magnitude using inverse-square law
					var force_magnitude = attraction_strength / (distance * distance)
					# Apply the impulse at the object's center of mass
					object.apply_central_force(direction * force_magnitude)
					object.gravity_scale = object.gravity_scale / distance
					# Cap the object's velocity
					if object.linear_velocity.length() > max_velocity:
						object.linear_velocity = object.linear_velocity.normalized() * max_velocity
	
	# Update previous objects list
	previous_objects_in_gravity_field = objects_in_gravity_field.duplicate()
