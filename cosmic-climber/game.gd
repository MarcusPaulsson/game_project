extends Node2D

@onready var main_music_player = $AudioStreamPlayer
var music_on = false
var music_volume = 0.8  # Normalized value between 0 and 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if music_on:
		main_music_player.play()
		main_music_player.volume_db = normalize_to_db(music_volume)
		main_music_player.autoplay = true

# Function to normalize volume between 0 and 1 to decibels
func normalize_to_db(normalized_value: float) -> float:
	# Mapping 0 (mute) to -80 dB and 1 (max volume) to 0 dB
	if normalized_value <= 0:
		return -80  # -80 dB is considered mute
	return lerp(-80, 0, normalized_value)

# Optional method to update the volume in runtime
func set_music_volume(new_volume: float) -> void:
	music_volume = clamp(new_volume, 0, 1)
	main_music_player.volume_db = normalize_to_db(music_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
