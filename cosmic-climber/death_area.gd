extends Area2D

@onready var timer = $Timer
@onready var death_sound = $death_sound

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Only the player should trigger the timer
		print("restart")
		death_sound.play()
		timer.start()
		
	elif body is RigidBody2D:
		body.global_position = body.initial_position
		print(body.global_position) # TODO Fix bug where this is needed
		body.linear_velocity = Vector2()
		body.angular_velocity = 0
		body.rotation = 0
		body.position = body.initial_position
				

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_timer_child_entered_tree(node: Node) -> void:
	timer.wait_time = 2.2
