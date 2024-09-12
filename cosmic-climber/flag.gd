extends Area2D
var count = 0
var level_count 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("HERE")
	if (count > 0):
		get_tree().change_scene_to_file("res://level_2.tscn")
	count+=1
