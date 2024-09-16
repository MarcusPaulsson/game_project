extends Area2D

@onready var timer = $Timer
@onready var death_sound = $death_sound

func _on_body_entered(body: Node2D) -> void:
	print("restart")
	death_sound.play()
	timer.start()
	


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_timer_child_entered_tree(node: Node) -> void:
	timer.wait_time = 2.2
