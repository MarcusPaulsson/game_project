extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var num_jumps = 0
const MULTI_JUMP = 1 # Allow a maximum of 1 jumps (double jump)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var can_jump = true
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and num_jumps < MULTI_JUMP:
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
		can_jump = false

	# Reset jump when touching the floor
	if is_on_floor():
		can_jump = true
		num_jumps = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
