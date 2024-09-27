extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var num_jumps = 0
const MULTI_JUMP = 2 # Allow a maximum of 1 jumps (double jump)
var sound_on = true
var acceleration_time = 0.2 # Time to reach max speed in seconds
var deceleration_time = 0.14 # Time to fully stop
var current_speed_x = 0.0 # Tracks current speed for the x-axis
var canPick = true

var previous_global_position: Vector2
var current_global_speed: float = 0.0


var current_dir = 1 # 1 for right, -1 for left
@onready var boxpick_ref = $Marker2D 
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound_1 = $jump1
@onready var jump_sound_2 = $jump2

var random = RandomNumberGenerator.new()
func _ready() -> void:
	previous_global_position = self.global_position
	# Initialization code here
	# For example, setting default values or connecting signals
	sprite.animation = "idle"  # Set default animation
	sprite.play()  # Start playing the default animation if needed
	if not sound_on:
		jump_sound_1.volume_db = -80
		jump_sound_2.volume_db = -80

func _physics_process(delta: float) -> void:
	current_global_speed = previous_global_position.distance_to(self.global_position)/delta
	previous_global_position = self.global_position
	# Add gravity
	if is_on_floor():
		num_jumps = 0
		if abs(current_global_speed) > 10:
			sprite.animation = "running"
		
		# 300 is the current max speed
		var speed_factor = clamp(abs(velocity.x) / 299, 0.3, 10.0)
		sprite.speed_scale = speed_factor

	if not is_on_floor():
		sprite.animation = "jump"
		velocity += get_gravity() * delta

	if abs(current_global_speed) < 10:
		sprite.animation = "idle"
		sprite.speed_scale = 1

	# Handle continuous jumping while on the floor
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if num_jumps == 0:
			jump_sound_2.play()  # Play jump sound when jumping from the ground
		num_jumps = 1  # Mark that the player has jumped once

	# Handle double jump while in the air
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and num_jumps < MULTI_JUMP:
		velocity.y = JUMP_VELOCITY
		jump_sound_1.play()  # Play double jump sound
		num_jumps += 1  # Increment the jump counter to prevent further double jumps

	# Handle horizontal movement with exponential easing
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		# Accelerate with an exponential curve toward max speed
		current_speed_x = lerp(current_speed_x, direction * SPEED, delta / acceleration_time)
		
		# Flip the sprite horizontally based on the direction
		sprite.flip_h = direction < 0
		current_dir = direction
		boxpick_ref.position.x = direction * 8
	else:
		# Decelerate with an exponential curve toward 0
		current_speed_x = lerp(current_speed_x, 0.0, delta / deceleration_time)

	# Apply the calculated horizontal speed to velocity
	velocity.x = current_speed_x
	
	move_and_slide()
