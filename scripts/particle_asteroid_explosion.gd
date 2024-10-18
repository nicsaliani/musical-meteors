class_name ParticleAsteroidExplosion extends GPUParticles2D

## VARIABLES
## -------------------
var color: Color
var accidental: Asteroid.AccidentalType

## FUNCTIONS
## -------------------
func _ready() -> void:
	
	process_material = process_material.duplicate()
	
	emitting = true
	modulate = color

	match accidental:
		Asteroid.AccidentalType.FLAT:
			texture = preload("res://assets/sprites/particles/particle_sheet_flat.png")
		Asteroid.AccidentalType.SHARP:
			texture = preload("res://assets/sprites/particles/particle_sheet_sharp.png")

func _process(_delta: float) -> void:
	if emitting == false:
		queue_free()
