class_name ScorePanel extends Control

## ON-READY REFERENCES
## -------------------
@onready var asteroid_manager: AsteroidManager = %"AsteroidManager"
@onready var score_label: Label = $Control/ScoreLabel

## VARIABLES
## -------------------
var score: int = 0

## FUNCTIONS
## -------------------
func _process(_delta: float) -> void:
	score_label.text = "SCORE: " + str(GameManager.get_score())
