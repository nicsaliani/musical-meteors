class_name ParticleAsteroidExplosion extends GPUParticles2D

## VARIABLES
## -------------------
var color: Color
var accidental: Asteroid.AccidentalType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	process_material = process_material.duplicate()
	
	emitting = true
	process_material.color = color

	match accidental:
		Asteroid.AccidentalType.FLAT:
			texture = preload("res://assets/sprites/particles/particle_sheet_flat.png")
		Asteroid.AccidentalType.SHARP:
			texture = preload("res://assets/sprites/particles/particle_sheet_sharp.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if emitting == false:
		queue_free()
