extends Control

var GAME_STARTED = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void: # start game button
	GAME_STARTED = true
	get_tree().change_scene_to_file("res://game.tscn")
	print("Pressed Start game")


func _on_load_game_pressed() -> void:  # load game button
	GAME_STARTED = true
	print("Pressed load game")


func _on_settings_pressed() -> void: # load game button
	print("Pressed Setting")
	
	
func _on_button_pressed() -> void: # 'how to play' button
	print("pressed how to play")
	
func _on_exit_pressed() -> void:
	print("pressed exit")
	# SAVE!!!!
	get_tree().quit()
	
	
	
	
	
	
