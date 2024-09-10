extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var num_jumps = 0
const MULTI_JUMP = 2 # Allow a maximum of 1 jumps (double jump)

var acceleration_time = 0.2 # Time to reach max speed in seconds
var deceleration_time = 0.14 # Time to fully stop
var current_speed_x = 0.0 # Tracks current speed for the x-axis

func _physics_process(delta: float) -> void:
	# Add gravity
	if is_on_floor():
		num_jumps = 0
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and num_jumps < MULTI_JUMP:
		velocity.y = JUMP_VELOCITY
		num_jumps += 1

	# Reset jump when touching the floor
	

	# Handle horizontal movement with exponential easing
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		# Accelerate with an exponential curve toward max speed
		current_speed_x = lerp(current_speed_x, direction * SPEED, delta / acceleration_time)
	else:
		# Decelerate with an exponential curve toward 0
		current_speed_x = lerp(current_speed_x, 0.0, delta / deceleration_time)

	# Apply the calculated horizontal speed to velocity
	velocity.x = current_speed_x

	# Move and slide
	move_and_slide()
