extends Node2D

@onready var sound = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
var config = load("res://read_write_config.gd").new()
func _ready() -> void:
	var data = config.load_local_data()
	var sound_bool = data[4]
	if sound_bool:
		sound.play()
		sound.volume_db = -15
		sound.autoplay = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
