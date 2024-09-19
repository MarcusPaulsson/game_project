extends Area2D

@onready var timer = $Timer
@onready var death_sound = $death_sound

var body_to_reset: Node2D = null  # Store a reference to the body that needs to be reset

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Only the player should trigger the timer
		print("restart")
		death_sound.play()
		death_sound.volume_db = -1  # Adjust volume as needed
		body_to_reset = body  # Store the reference to the player
		timer.start()  # Start the timer (no arguments needed)
		
	elif body is RigidBody2D:
		body.global_position = body.initial_position
		print(body.global_position) # TODO Fix bug where this is needed
		body.linear_velocity = Vector2()
		body.angular_velocity = 0
		body.rotation = 0
		body.position = body.initial_position

func _on_timer_timeout() -> void:
	if body_to_reset != null:
		# Reset the player position when the timer finishes
		body_to_reset.position = Vector2(0, 0)  # Reset to (0,0) or another desired position
		print("Position reset to:", body_to_reset.position)
		body_to_reset = null  # Clear the reference after resetting

func _on_timer_child_entered_tree(node: Node) -> void:
	timer.wait_time = 2.2
