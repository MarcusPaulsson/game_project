extends CollisionShape2D

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("HERE")
	if (count == 0):
		print(get_tree().current_scene.name)
		get_tree().change_scene_to_file("res://levels/level_3.tscn")
		count+=1
