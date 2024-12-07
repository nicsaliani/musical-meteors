class_name ScorePanel extends Control

## SIGNALS
signal level_up(level)

@export var level_up_sounds: Dictionary = {}

## ON-READY REFERENCES
@onready var asteroid_manager: AsteroidManager = %"AsteroidManager"
@onready var score_label: Label = $Control/ScoreLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## VARIABLES
var score: int = 0
var level: int = 1
var level_thresholds: Array[int] = [
	250,
	750,
	1500,
	2500,
	4000,
	5000,
	6000,
	7500,
	9000,
	10000
]


## FUNCTIONS
func _process(_delta: float) -> void:
	score_label.text = "SCORE: " + str(score)


func _on_start_game_button_pressed() -> void:
	score = 0
	level = 1


func _on_asteroid_manager_update_score(points: Variant) -> void:
	update_score(points)


func update_score(_points) -> void:
	score += _points
	check_for_level_up(score)


func check_for_level_up(_score) -> void:
	if score < level_thresholds[0]:
		set_level(1)
	elif score >= level_thresholds[0] and score < level_thresholds[1]:
		set_level(2)
	elif score >= level_thresholds[1] and score < level_thresholds[2]:
		set_level(3)
	elif score >= level_thresholds[2] and score < level_thresholds[3]:
		set_level(4)
	elif score >= level_thresholds[3] and score < level_thresholds[4]:
		set_level(5)
	elif score >= level_thresholds[4] and score < level_thresholds[5]:
		set_level(6)
	elif score >= level_thresholds[5] and score < level_thresholds[6]:
		set_level(7)
	elif score >= level_thresholds[6] and score < level_thresholds[7]:
		set_level(8)
	elif score >= level_thresholds[7] and score < level_thresholds[8]:
		set_level(9)
	else:
		set_level(10)


func play_level_up_sound(_sound: int) -> void:
	audio_stream_player.stream = preload("res://assets/sounds/level_up/level_up_f.wav")
	audio_stream_player.play()


func set_level(_new_level: int) -> void:
	if level < _new_level:
		level = _new_level
		level_up.emit(level)
		play_level_up_sound(_new_level - 2)
