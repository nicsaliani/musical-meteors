class_name ScoreManager extends Control

## ON-READY REFERENCES
## -------------------
@onready var asteroid_manager: AsteroidManager = %"AsteroidManager"
@onready var score_label: Label = $ScoreLabel

@export var score_popup: PackedScene
## VARIABLES
## -------------------
var score: int = 0

## FUNCTIONS
## -------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	asteroid_manager.connect("asteroid_destroyed", update_score)
	score_label.text = str(score)

func update_score(_asteroid):
	
	var _points = _asteroid.points
	var _pos = _asteroid.position
	
	score += _points
	score_label.text = str(score)
	
	spawn_score_popup(_points, _pos)

func spawn_score_popup(_points: int, _pos: Vector2):
	
	var _popup = score_popup.instantiate()
	_popup.points = _points
	_popup.text = str(_popup.points)
	_popup.global_position = _pos - Vector2(_popup.size.x / 2, _popup.size.y / 2,)
	get_node("../../Particles").add_child(_popup)
