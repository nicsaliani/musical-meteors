class_name MusicPlayer extends AudioStreamPlayer

@export var main_menu_music: AudioStream
@export var game_music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = main_menu_music
	play()


func _on_start_game_button_pressed() -> void:
	await fade_out(3.0)
	stream = game_music
	fade_in(3.0)


func fade_out(fade_time: float) -> void:
	var volume_tween := get_tree().create_tween()
	volume_tween.tween_property(self, "volume_db", -50, fade_time)
	await volume_tween.finished
	stop()


func fade_in(fade_time: float) -> void:
	play()
	var volume_tween := get_tree().create_tween()
	volume_tween.tween_property(self, "volume_db", 0, fade_time)


func _on_game_timer_panel_game_over() -> void:
	stop()
