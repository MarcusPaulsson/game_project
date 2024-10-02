extends Node2D

@onready var text_edit = $Sprite2D/TextEdit  # Reference to the TextEdit component
var elapsed_time = 0.0  # Variable to track the elapsed time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Accumulate the elapsed time
	elapsed_time += delta
	
	# Calculate minutes, seconds, and tenths of a second
	var minutes = int(elapsed_time) / 60  # Convert total time to minutes
	var seconds = int(elapsed_time) % 60  # Get remaining seconds
	var tenths = int(int(elapsed_time * 10) % 10)  # Get the tenths of a second
	
	# Format the time as MM:SS:T, ensuring two digits for minutes and seconds, and one digit for tenths
	var time_display = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(tenths)
	
	# Update the TextEdit with the formatted time
	text_edit.text = time_display
