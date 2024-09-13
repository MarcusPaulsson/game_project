extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var num_jumps = 0
const MULTI_JUMP = 2 # Allow a maximum of 1 jumps (double jump)

var acceleration_time = 0.2 # Time to reach max speed in seconds
var deceleration_time = 0.14 # Time to fully stop
var current_speed_x = 0.0 # Tracks current speed for the x-axis
var canPick = true
var current_dir = 1 # 1 for right, -1 for left
@onready var boxpick_ref = $Marker2D # Reference to the object (boxpick_ref)
@onready var sprite = $AnimatedSprite2D


func _ready() -> void:
	# Initialization code here
	# For example, setting default values or connecting signals
	sprite.animation = "idle"  # Set default animation
	sprite.play()  # Start playing the default animation if needed


func _physics_process(delta: float) -> void:
	
	# Add gravity
	if is_on_floor():
		num_jumps = 0
		if abs(current_speed_x) > 10:
			sprite.animation = "running"
		# Scale the speed between a minimum and maximum value
		# Normalize the speed to a range suitable for the animation
		# 300 is the current max speed
			var speed_factor = clamp(abs(velocity.x) / 300, 0.3, 10.0)
			sprite.speed_scale = speed_factor
	
	if not is_on_floor():
		sprite.animation = "jump"
		velocity += get_gravity() * delta
		
		
		
	if abs(current_speed_x) < 10:
		sprite.animation = "idle"
		sprite.speed_scale = 1
		
	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and num_jumps < MULTI_JUMP:
		velocity.y = JUMP_VELOCITY
		num_jumps += 1

	# Handle horizontal movement with exponential easing
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		# Accelerate with an exponential curve toward max speed
		current_speed_x = lerp(current_speed_x, direction * SPEED, delta / acceleration_time)
		
		# Flip the sprite horizontally based on the direction
		sprite.flip_h = direction < 0
		current_dir = direction
		boxpick_ref.position.x = 9+direction*5
		
	else:
		# Decelerate with an exponential curve toward 0
		current_speed_x = lerp(current_speed_x, 0.0, delta / deceleration_time)
	
	# Apply the calculated horizontal speed to velocity
	velocity.x = current_speed_x
	sprite.play()
	# Move and slide
	move_and_slide()
