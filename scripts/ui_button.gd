class_name UIButton extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var sound_on_click: AudioStream

func _ready() -> void:
	audio_stream_player.stream = sound_on_click


func _on_pressed() -> void:
	audio_stream_player.play()
