extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var num_jumps = 0
const MULTI_JUMP = 2 # Allow a maximum of 2 jumps (double jump)
var sound_on = true
var acceleration_time = 0.2 # Time to reach max speed in seconds
var deceleration_time = 0.14 # Time to fully stop
var current_speed_x = 0.0 # Tracks current speed for the x-axis
var canPick = true

var previous_global_position: Vector2
var current_global_speed: float = 0.0
var current_dir: int = 1 # 1 for right, -1 for left

var still_time: float = 1.0 # Time to stay still at the start
var first_run_time: float = 1.0 # Time for running in seconds
var stop_time: float = 0.8 # Time for stopping in seconds
var second_run_time: float = 0.7 # Time for second running in seconds
var jump_air_time: float = 0.6 # Time to keep moving while in the air after jumping
var first_jump_time: float = 0.7 # Time to trigger the first jump
var second_jump_time: float = 0.3 # Time to trigger the second jump after the first
var second_still_time: float = 1.0 # Time to stay still before the second double jump
var second_jump_air_time: float = 0.4 # Time to move right while in the air after the second double jump
var total_time: float = 0.0 # Total elapsed time

var jump_timer: float = 0.0 # Timer for controlling the jump sequence
var jump_count = 0 # Tracks the number of jumps
var is_final_stage: bool = false # Track whether the player is in the final still stage
var is_second_jump: bool = false # Track if we're in the second jump phase
var is_second_jump_done: bool = false # Track if the second jump is complete

@onready var boxpick_ref = $Marker2D 
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound_1 = $jump1
@onready var jump_sound_2 = $jump2

func _ready() -> void:
	previous_global_position = self.global_position
	sprite.animation = "idle"  # Set default animation
	sprite.play()  # Start playing the default animation if needed
	if not sound_on:
		jump_sound_1.volume_db = -80
		jump_sound_2.volume_db = -80

func _physics_process(delta: float) -> void:
	# Only proceed with movement if not in the final stage
	if not is_final_stage:
		total_time += delta

		# Stage 1: Stay still for 1 second
		if total_time <= still_time:
			current_speed_x = 0 # Stay still
		# Stage 2: Run for 1 second
		elif total_time <= still_time + first_run_time:
			current_speed_x = SPEED # Running to the right
		# Stage 3: Stop for 0.8 seconds but keep facing right
		elif total_time <= still_time + first_run_time + stop_time:
			current_speed_x = 0 # Stop movement but keep facing right
		# Stage 4: Run again for 0.7 seconds
		elif total_time <= still_time + first_run_time + stop_time + second_run_time:
			current_speed_x = SPEED # Running to the right again
		# Stage 5: Perform the first jump after running for a total of 2.5 seconds
		elif total_time > still_time + first_run_time + stop_time + second_run_time and jump_count == 0:
			velocity.y = JUMP_VELOCITY
			jump_sound_1.play()  # Play first jump sound
			jump_count += 1 # Track that the first jump has occurred
			jump_timer = 0.0 # Reset the jump timer for the second jump
		# Stage 6: Time-based second jump after the first jump
		elif jump_count == 1 and jump_timer >= second_jump_time:
			velocity.y = JUMP_VELOCITY
			jump_sound_2.play()  # Play second jump sound
			jump_count += 1 # Track that the second jump has occurred
		# Stage 7: After the double jump, keep moving right in the air for a short time, then stop
		elif jump_count >= 1:
			jump_timer += delta
			if jump_timer < jump_air_time:
				current_speed_x = SPEED # Keep moving right in the air
			else:
				current_speed_x = 0 # Stop after the air time
				is_second_jump = true # Move to the second jump sequence

	# Second Jump Sequence (keeping the same structure):
	if is_second_jump and not is_second_jump_done:
		# Stand still for 1 second before the second jump
		if total_time <= still_time + first_run_time + stop_time + second_run_time + jump_air_time + second_still_time:
			current_speed_x = 0 # Stand still before second double jump
		# Perform the first jump while moving right
		elif total_time <= still_time + first_run_time + stop_time + second_run_time + jump_air_time + second_still_time + first_jump_time and jump_count == 2:
			current_speed_x = SPEED # Move right while performing first jump of second sequence
			velocity.y = JUMP_VELOCITY
			jump_sound_1.play()  # Play first jump sound of second double jump
			jump_count += 1 # Increment for the second double jump
		# Perform the second jump while moving right
		elif total_time > still_time + first_run_time + stop_time + second_run_time + jump_air_time + second_still_time + first_jump_time and jump_count == 3 and total_time < still_time + first_run_time + stop_time + second_run_time + jump_air_time + second_still_time + first_jump_time + second_jump_time:
			current_speed_x = SPEED # Keep moving right while performing second jump of second sequence
			velocity.y = JUMP_VELOCITY
			jump_sound_2.play()  # Play second jump sound of second double jump
			jump_count += 1 # Increment after second jump
		# Move right in the air for 0.4 seconds and then stop
		elif total_time < still_time + first_run_time + stop_time + second_run_time + jump_air_time + second_still_time + first_jump_time + second_jump_air_time:
			current_speed_x = SPEED # Continue moving right after second double jump
		else:
			current_speed_x = 0 # Stop after air time
			is_second_jump_done = true # Transition to final idle stage

	# Final Stage: Stand completely still, but only after landing
	if is_second_jump_done and is_on_floor():
		current_speed_x = 0 # Remain still for the rest of the time after landing
		sprite.animation = "idle"
		is_final_stage = true # Transition to final stage

	# Calculate the distance vector between the previous and current positions
	var position_diff = self.global_position - previous_global_position
	
	# Calculate the speed as the magnitude of the position difference
	current_global_speed = position_diff.length() / delta

	previous_global_position = self.global_position

	# Add gravity
	if is_on_floor():
		num_jumps = 0
		jump_count = 0 # Reset jump count when the player touches the ground
		jump_timer = 0.0 # Reset jump timer
		if abs(current_global_speed) > 10 and not is_final_stage:
			sprite.animation = "running"
		
		# Adjust animation speed based on current movement speed
		var speed_factor = clamp(current_global_speed / 299, 0.3, 10.0)
		sprite.speed_scale = speed_factor
	else:
		sprite.animation = "jump"
		velocity += get_gravity() * delta

	if abs(current_global_speed) < 10 and is_on_floor() and not is_final_stage:
		sprite.animation = "idle"
		sprite.speed_scale = 1

	# Flip the sprite horizontally based on the current direction
	sprite.flip_h = current_dir < 0
	boxpick_ref.position.x = current_dir * 8

	# Apply the calculated horizontal speed to velocity
	velocity.x = current_speed_x * current_dir # Move in the direction of current_dir
	
	# Apply movement
	move_and_slide()
