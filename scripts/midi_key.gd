extends Node

enum KeyType{
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
	B,
}

# Set this field in the inspector to the desired note. 
# For example, set this to "C" to make it a C key.
@export var key_name: KeyType

@onready var animated_sprite = $AnimatedSprite2D

var valid_keys: Array[int]
var is_pressed := false
var keys_held := 0

func _ready():
	# This match statement sets valid_keys to contain every possible MIDI pitch
	# corresponding to the selected key_name in the inspector.
	# For example, setting key_name to "C" will assign valid_keys an array
	# containing every possible "C" MIDI pitch.
	match key_name:
		0:	# Every C Key
			valid_keys = [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120]
		1:	# Every CD Key
			valid_keys = [1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121]
		2:	# Every D Key
			valid_keys = [2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122]
		3:	# Every DE Key
			valid_keys = [3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123]
		4:	# Every E Key
			valid_keys = [4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124]
		5:	# Every F Key
			valid_keys = [5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125]
		6:	# Every FG Key
			valid_keys = [6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126]
		7:	# Every G Key
			valid_keys = [7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127]
		8:	# Every GA Key
			valid_keys = [8, 20, 32, 44, 56, 68, 80, 92, 104, 116]
		9:	# Every A Key
			valid_keys = [9, 21, 33, 45, 57, 69, 81, 93, 105, 117]
		10:	# Every AB Key
			valid_keys = [10, 22, 34, 46, 58, 70, 82, 94, 106, 118]
		11:	# Every B Key
			valid_keys = [11, 23, 35, 47, 59, 71, 83, 95, 107, 119]

func check_key(pitch: int, velocity: int):
	if valid_keys.has(pitch):
		if velocity > 0:
			if keys_held == 0:
				print("%s key pressed." % [KeyType.keys()[key_name]])
				animated_sprite.play("on")
			keys_held += 1
		elif velocity == 0:
			if keys_held == 1:
				print("%s key released." % [KeyType.keys()[key_name]])
				animated_sprite.play("off")
			keys_held -=1
