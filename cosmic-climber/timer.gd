extends Node2D

@onready var text_edit = $Sprite2D/TextEdit  # Reference to the TextEdit component
var elapsed_time = 0.0  # Variable to track the elapsed time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Accumulate the elapsed time
	elapsed_time += delta
	# Format the time as seconds (or minutes if you want to extend it)
	var time_display =  str(elapsed_time)
	# Update the TextEdit with the elapsed time
	text_edit.text = time_display
