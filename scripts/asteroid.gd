class_name Asteroid extends Area2D

signal asteroid_spawned

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var asteroid_sprite_2d: Sprite2D = $AsteroidSprite2D
@onready var symbol_sprite_2d: Sprite2D = $SymbolSprite2D

## METEOR SIZES
enum SizeType {SMALL, MEDIUM, LARGE}

## METEOR PITCHES
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

## METEOR COLORS
var ColorType: Dictionary = {
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

@export var size: SizeType
@export var pitch: PitchType

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
				
var pitch_letter: String
var valid_pitches: Array[int]
var movement_vector := Vector2(0, -1)
var rotate_value: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_size_vars()
	set_pitch_vars()
	
	rotate_value = randf_range(0, 2*PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += movement_vector.rotated(rotate_value) * speed * delta
	screen_wrap()
	
func set_size_vars():
	
	## Set speed, hitbox, and asteroid sprite
	## based on randomly-chosen size enum.
	
	#size = randi_range(0, SizeType.size() - 1)
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

func set_pitch_vars():
	
	## Set color, valid pitches, and symbol sprite
	## based on randomly-chosen pitch enum.
	
	#pitch = randi_range(0, PitchType.size() - 1)
	var symbol_flip = randi_range(0, 2)
	match pitch:
		0:	## Every C Key
			valid_pitches = [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_c.png")
		1:	## Every CD Key
			valid_pitches = [1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121]
			if symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_cs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_df.png")
		2:	## Every D Key
			valid_pitches = [2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_d.png")
		3:	## Every DE Key
			valid_pitches = [3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123]
			if symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ds.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_ef.png")
		4:	## Every E Key
			valid_pitches = [4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_e.png")
		5:	## Every F Key
			valid_pitches = [5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_f.png")
		6:	## Every FG Key
			valid_pitches = [6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126]
			if symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_fs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gf.png")
		7:	## Every G Key
			valid_pitches = [7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_g.png")
		8:	## Every GA Key
			valid_pitches = [8, 20, 32, 44, 56, 68, 80, 92, 104, 116]
			if symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_gs.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_af.png")
		9:	## Every A Key
			valid_pitches = [9, 21, 33, 45, 57, 69, 81, 93, 105, 117]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_a.png")
		10:	## Every AB Key
			valid_pitches = [10, 22, 34, 46, 58, 70, 82, 94, 106, 118]
			if symbol_flip:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_as.png")
			else:
				symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_bf.png")
		11:	## Every B Key
			valid_pitches = [11, 23, 35, 47, 59, 71, 83, 95, 107, 119]
			symbol_sprite_2d.texture = preload("res://assets/sprites/symbols/symbol_b.png")

	modulate = ColorType[pitch]
	pitch_letter = PitchType.keys()[pitch]
	

func screen_wrap():
	var shape_radius = collision_shape_2d.shape.radius
	#var screen_size = get_viewport_rect().size
	# SCREEN WRAP (X)
	if global_position.x + shape_radius < -256:
		global_position.x = 256 + shape_radius
	elif global_position.x - shape_radius > 256:
		global_position.x = -256 - shape_radius
		
	# SCREEN WRAP (Y)
	if global_position.y + shape_radius < -256:
		global_position.y = 256 + shape_radius
	elif global_position.y - shape_radius > 256:
		global_position.y = -256 - shape_radius
