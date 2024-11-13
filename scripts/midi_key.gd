class_name MidiKey extends Node2D

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
var pressed := false
var active := true
var keys_held := 0

## FUNCTIONS
## -------------------
func _ready():
	pitch_letter = PitchType.keys()[pitch_type]


func _process(_delta: float) -> void:
	modulate = Color.WHITE if active else Color.DIM_GRAY


func call_key(_velocity: int, _message: int) -> void:
	
	if _velocity > 0 and _message == 9:
		if keys_held == 0:
			press()
		keys_held += 1
	elif _velocity == 0 or _message == 8:
		if keys_held == 1:
			release()
		if keys_held > 0:
			keys_held -=1
	print("Keys held: ", keys_held)


func press() -> void:
	pressed = true
	animated_sprite.play("on")
	midi_key_pressed.emit(pitch_letter)


func release() -> void:
	pressed = false
	animated_sprite.play("off")


func set_active(_active: bool) -> void:
	#active = true if _active else false
	keys_held = 0
	if _active:
		active = true
	else:
		active = false
		
		if is_pressed():
			release()


func is_active() -> bool:
	return true if active else false


func is_pressed() -> bool:
	return true if pressed else false
