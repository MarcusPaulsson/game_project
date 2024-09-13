extends RigidBody2D

var picked = false
var held_object = null

# Reference to the collision shape node
var collision_shape

# Called when the node is added to the scene
func _ready() -> void:
	# Get reference to the collision shape node
	collision_shape = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if picked == true:
		# Make the item follow the player's position
		self.position = get_node("../player/Marker2D").global_position
		# Disable the collision shape when picked up
		collision_shape.disabled = true
	else:
		# Enable the collision shape when dropped
		collision_shape.disabled = false


func _input(event):
	# Drop item if currently holding it
	if Input.is_action_just_pressed("ui_pick_or_throw"):
		# Check if the player is holding an item
		if picked == true and get_node("../player").canPick == false:
			print("Throwing item")
			picked = false # Release the item
			# Get player node and velocity
			var player = get_node("../player")
			var player_velocity = player.velocity # Assuming player has a velocity property
			
			# Set initial throw direction based on player's facing direction
			var throw_direction = player_velocity # Default throw vector
			# Apply player's velocity to the throw for added momentum
			self.linear_velocity = throw_direction * 1.5
			print(self.linear_velocity)
			# Reset item position relative to the player's position slightly below
			self.position = player.get_node("Marker2D").position
			# Allow player to pick up items again
			player.canPick = true
		# If not holding an item, check if the player can pick one up
		else:
			var bodies = $pick_up_area.get_overlapping_bodies()
			for body in bodies:
				if body.name == "player" and get_node("../player").canPick == true:
					print("picked up item")
					picked = true
					get_node("../player").canPick = false
