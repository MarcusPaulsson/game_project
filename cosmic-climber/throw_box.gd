extends RigidBody2D


var picked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if picked == true:
		self.position = get_node("../player/Position2D").global_position

func _input(event):
	if Input.is_action_just_pressed("ui_pick_or_throw"):
		print("here1")
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "player" and get_node("../player").canPick == true:
				picked = true
				get_node("../player").canPick = false
	elif Input.is_action_just_pressed("ui_pick_or_throw") and picked == true:
		print("here2")
		picked = false
		get_node("../player").canPick = true
		#if get_node("../player").sprite.flip_h == false:
			#apply_impulse(Vector2(), Vector2(90, -10))
		#else:
			#apply_impulse(Vector2(), Vector2(-90, -10))		
	if Input.is_action_just_pressed("ui_pick_or_throw") and picked == true:
		print("here3")
		get_node("../player").canPick = true
		#if get_node("../player").get == false:
			#apply_impulse(Vector2(), Vector2(150, -200))
		#else:
			#apply_impulse(Vector2(), Vector2(-150, -200))	
