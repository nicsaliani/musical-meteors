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

# Create a key for each pitch related to the chosen KeyType.
# For example, create increments of 12 starting from 0 to 120
# to include every valid register of C.
@export var valid_notes: Dictionary

@onready var animated_sprite = $AnimatedSprite2D

var is_pressed := false
var keys_held := 0

func check_key(pitch: int, velocity: int):
	if valid_notes.has(pitch):
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
