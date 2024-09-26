class_name Asteroid extends Area2D

## SIGNALS
## -------------------
signal split_asteroid(pos, size)

## ON-READY REFERENCES
## -------------------
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var asteroid_sprite_2d: Sprite2D = $AsteroidSprite2D
@onready var symbol_sprite_2d: Sprite2D = $SymbolSprite2D

## EXPORT REFERENCES
## -------------------
@export var size: Asteroid.SizeType
@export var pitch: Asteroid.PitchType

## ENUMS
## -------------------
enum SizeType {SMALL, MEDIUM, LARGE}

enum PitchType {
	C,
	CD,
	D,
	DE,
	E,
	F,
	FG,
	G,
	GA,
	A,
	AB,
	B
}

## VARIABLES
## -------------------
const color_dict: Dictionary = {
	0: Color.BLUE,
	1: Color.AQUAMARINE,
	2: Color.YELLOW,
	3: Color.MEDIUM_SPRING_GREEN,
	4: Color.CYAN,
	5: Color.PURPLE,
	6: Color.WEB_PURPLE,
	7: Color.GREEN,
	8: Color.INDIAN_RED,
	9: Color.RED,
	10: Color.SADDLE_BROWN,
	11: Color.DARK_ORANGE
}

var movement_vector := Vector2(0, -1)
var pitch_letter: String
var rotate_value: float
var speed: int:
	get:
		match size:
			SizeType.SMALL:
				return 45
			SizeType.MEDIUM:
				return 30
			SizeType.LARGE:
				return 15
			_:
				return 0
var points: int:
	get:
		match size:
			SizeType.SMALL:
				return 50
			SizeType.MEDIUM:
				return 100
			SizeType.LARGE:
				return 200
			_:
				return 0

## FUNCTIONS
## -------------------
func _ready() -> void:
	
	pitch_letter = PitchType.keys()[pitch]
	modulate = color_dict[pitch]
	rotate_value = randf_range(0, 2*PI)
	
	# Set asteroid sprite and collision shape based on size
	match size:
		SizeType.SMALL:
			asteroid_sprite_2d.texture = preload("res://assets/spr_asteroid_small.png")
			collision_shape_2d.shape = preload("res://resources/col_asteroid_small.tres")
		SizeType.MEDIUM:
			asteroid_sprite_2d.texture = preload("res://assets/spr_asteroid_medium.png")
			collision_shape_2d.shape = preload("res://resources/col_asteroid_medium.tres")
		SizeType.LARGE:
			asteroid_sprite_2d.texture = preload("res://assets/spr_asteroid_large.png")
			collision_shape_2d.shape = preload("res://resources/col_asteroid_large.tres")
	
	# Set pitch symbol sprite based on pitch (random flip for accidentals)
	var _symbol_flip = randi_range(0, 2)
	match pitch:
		0:	# C
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_c.png")
		1:	# CD
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_cs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_df.png")
		2:	# D
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_d.png")
		3:	# DE
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ds.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ef.png")
		4:	# E
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_e.png")
		5:	# F
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_f.png")
		6:	# FG
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_fs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gf.png")
		7:	# G
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_g.png")
		8:	# GA
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_af.png")
		9:	# A
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_a.png")
		10:	# AB
			if _symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_as.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_bf.png")
		11:	# B
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_b.png")

func _process(_delta: float) -> void:
	
	# X/Y Movement
	global_position += movement_vector.rotated(rotate_value) * speed * _delta
	
	# radius of asteroid's collision shape used to calculate screen wrapping
	var _shape_radius = collision_shape_2d.shape.radius
	
	# Screen Wrap (X)
	if global_position.x + _shape_radius < -256:
		global_position.x = 256 + _shape_radius
	elif global_position.x - _shape_radius > 256:
		global_position.x = -256 - _shape_radius
		
	# Screen Wrap (Y)
	if global_position.y + _shape_radius < -256:
		global_position.y = 256 + _shape_radius
	elif global_position.y - _shape_radius > 256:
		global_position.y = -256 - _shape_radius

func explode():
	
	split_asteroid.emit(global_position, size)
	queue_free()
