extends Node

# Possible meteor sizes
enum SizeType {SMALL, MEDIUM, LARGE}
@export var size: SizeType

# Possible meteor pitches
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
var pitch: PitchType
var valid_pitches: Array[int]

@onready var asteroid_sprite_2d: Sprite2D = $AsteroidSprite2D
@onready var symbol_sprite_2d: Sprite2D = $AsteroidSprite2D/SymbolSprite2D
var color
var pitch_symbol
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Generate Size
	var size_type = randi_range(0, SizeType.size() - 1)
	match size_type:
		0:
			size = SizeType.SMALL
			# sprite = small meteor
		1:
			size = SizeType.MEDIUM
			# sprite = medium meteor
		2:
			size = SizeType.LARGE
			# sprite = large meteor

	## Generate Pitch
	var pitch_type = randi_range(0, PitchType.size() - 1)
	match pitch_type:
		0:	## Every C Key
			valid_pitches = [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120]
		1:	## Every CD Key
			valid_pitches = [1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121]
		2:	## Every D Key
			valid_pitches = [2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122]
		3:	## Every DE Key
			valid_pitches = [3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123]
		4:	## Every E Key
			valid_pitches = [4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124]
		5:	## Every F Key
			valid_pitches = [5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125]
		6:	## Every FG Key
			valid_pitches = [6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126]
		7:	## Every G Key
			valid_pitches = [7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127]
		8:	## Every GA Key
			valid_pitches = [8, 20, 32, 44, 56, 68, 80, 92, 104, 116]
		9:	## Every A Key
			valid_pitches = [9, 21, 33, 45, 57, 69, 81, 93, 105, 117]
		10:	## Every AB Key
			valid_pitches = [10, 22, 34, 46, 58, 70, 82, 94, 106, 118]
		11:	## Every B Key
			valid_pitches = [11, 23, 35, 47, 59, 71, 83, 95, 107, 119]
	
	## Generate Color, Symbol (based on Pitch)
	# color = colors[pitch_type]
	# pitch_symbol = pitch_symbols[pitch_type]
	# asteroid_sprite_2d.texture (sprite)
	
	# asteroid_sprite_2d.modulate (color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
