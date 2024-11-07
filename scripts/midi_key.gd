class_name MidiKey extends Node

## SIGNALS
## -------------------
signal midi_key_pressed(pitch)

## ON-READY REFERENCES
## -------------------
@onready var midi_control: MidiControl = %"MIDI Control"
@onready var animated_sprite = $AnimatedSprite2D

## EXPORT REFERENCES
## -------------------
@export var pitch_type: PitchType

## ENUMS
## -------------------
enum PitchType{
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

## VARIABLES
## -------------------
var pitch_letter: String
var is_pressed := false
var keys_held := 0

## FUNCTIONS
## -------------------
func _ready():
	pitch_letter = PitchType.keys()[pitch_type]

func call_key(_velocity: int, _message: int):
	if _velocity > 0 and _message == 9:
		if keys_held == 0:
			animated_sprite.play("on")
			midi_key_pressed.emit(pitch_letter)
		keys_held += 1
	elif _velocity == 0 or _message == 8:
		if keys_held == 1:
			animated_sprite.play("off")
		keys_held -=1
