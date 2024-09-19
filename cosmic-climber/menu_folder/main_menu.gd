extends Control

var GAME_STARTED = false
var DEBUG = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DEBUG:
		get_tree().change_scene_to_file("res://game.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void: # start game button
	GAME_STARTED = true
	get_tree().change_scene_to_file("res://game.tscn")
	print("Pressed Start game")


func _on_load_game_pressed() -> void:  # load game button
	GAME_STARTED = true
	get_tree().change_scene_to_file("res://menu_folder/load_menu.tscn")
	print("Pressed load game")


func _on_leaderboard_pressed() -> void: # leaderboard button
	get_tree().change_scene_to_file("res://menu_folder/leaderboard_menu.tscn")


func _on_settings_pressed() -> void: # load game button
	get_tree().change_scene_to_file("res://menu_folder/settings_menu.tscn")
	print("Pressed Setting")
	
	
func _on_button_pressed() -> void: # 'how to play' button
	get_tree().change_scene_to_file("res://levels/level_how_to_play.tscn")
	print("pressed how to play")
	
func _on_exit_pressed() -> void:
	print("pressed exit")
	# SAVE!!!!
	get_tree().quit()
	
	
	
	
	
	
