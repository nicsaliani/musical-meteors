extends Node

## ON-READY
@onready var meteor_explosion_sprite: Sprite2D = $MeteorExplosionSprite

## VARIABLES
var rotation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meteor_explosion_sprite.rotation_degrees = rotation
	
	await get_tree().create_timer(0.05).timeout
	queue_free()
