#Script for all kind of pick_up boxes!!!
extends RigidBody2D
@onready var box_type = $ObjCrate002
var picked = false
var held_object = null
var in_mag_field = false
# Reference to the collision shape node
var collision_shape
const metal_type = "<CompressedTexture2D#-9223371999290587739>"
@onready var pick_up_box_sound = $pick_up_box
var initial_position
var used_cells 
var distance = INF
func _ready() -> void:
	# Get reference to the collision shape node
	collision_shape = $CollisionShape2D
	# Store the object's initial position when it spawns
	initial_position = self.global_position
	# Get all painted blocks from the tile map layer


func _process(delta: float) -> void:
	
	if picked:
		# Make the item follow the player's position
		self.position = get_node("../player/Marker2D").global_position + Vector2(get_node("../player").current_dir * 28, 10)
		# Disable the collision shape when picked up
		collision_shape.disabled = true
	else:
	
		collision_shape.disabled = false
		if str(box_type.texture) == metal_type:
			pass

			
			

					
				

func _input(event):
	# Drop item if currently holding it
	if Input.is_action_just_pressed("ui_pick_or_throw"):
		
		# Check if the player is holding an item
		if picked and not get_node("../player").canPick:
			
			var player = get_node("../player")
			var player_velocity = player.velocity  # Assuming player has a velocity property
			self.position = get_node("../player/Marker2D").global_position + Vector2(player.current_dir * 28, 10)
			
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
					break
