class_name ParticleAsteroidExplosion extends GPUParticles2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## VARIABLES
var color: Color
var accidental: Asteroid.AccidentalType
var explosion_sound: AudioStream

## FUNCTIONS
func _ready() -> void:
	process_material = process_material.duplicate()
	
	emitting = true
	modulate = color

	match accidental:
		Asteroid.AccidentalType.FLAT:
			texture = preload("res://assets/sprites/particles/particle_sheet_flat.png")
		Asteroid.AccidentalType.SHARP:
			texture = preload("res://assets/sprites/particles/particle_sheet_sharp.png")
	
	var sound_chance = randi_range(0, 4)
	match sound_chance:
		0:
			explosion_sound = preload("res://assets/sounds/game/meteor_explosion_1.wav")
		1:
			explosion_sound = preload("res://assets/sounds/game/meteor_explosion_2.wav")
		2:
			explosion_sound = preload("res://assets/sounds/game/meteor_explosion_3.wav")
		3:
			explosion_sound = preload("res://assets/sounds/game/meteor_explosion_4.wav")
		4:
			explosion_sound = preload("res://assets/sounds/game/meteor_explosion_5.wav")
	
	audio_stream_player.stream = explosion_sound
	audio_stream_player.play()
	
	GameManager.connect("game_paused", _on_game_paused)
	GameManager.connect("game_unpaused", _on_game_unpaused)


func _process(_delta: float) -> void:	
	if emitting == false:
		queue_free()


func _on_game_paused():
	set_process(false)


func _on_game_unpaused():
	set_process(true)
