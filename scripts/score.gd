class_name ScoreText extends Label

## ON-READY REFERENCES
## -------------------
@onready var asteroid_manager: AsteroidManager = %"Asteroid Manager"

## VARIABLES
## -------------------
var score: int = 0

## FUNCTIONS
## -------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	asteroid_manager.connect("asteroid_destroyed", update_score)
	text = str(score)

func update_score(_asteroid):
	
	score += _asteroid.points
	text = str(score)
