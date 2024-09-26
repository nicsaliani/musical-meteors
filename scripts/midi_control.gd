class_name MidiControl extends Control

## SIGNALS
## -------------------
signal note_pressed

## EXPORT REFERENCES
## -------------------
@export var midi_keys: Array[Node]

## VARIABLES
## -------------------
var pitch_dict: Dictionary = {
	0: [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120],
	1: [1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121],
	2: [2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122],
	3: [3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123],
	4: [4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124],
	5: [5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125],
	6: [6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126],
	7: [7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127],
	8: [8, 20, 32, 44, 56, 68, 80, 92, 104, 116],
	9: [9, 21, 33, 45, 57, 69, 81, 93, 105, 117],
	10: [10, 22, 34, 46, 58, 70, 82, 94, 106, 118],
	11: [11, 23, 35, 47, 59, 71, 83, 95, 107, 119]
}

## FUNCTIONS
## -------------------
func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	for _midi_key in midi_keys:
		_midi_key.connect("midi_key_pressed", _on_midi_key_pressed)

func _input(_event):
	if _event is InputEventMIDI:
		if _event.message == 9 or _event.message == 8:
			var _midi_key = midi_keys[get_key_from_pitch(_event.pitch)]
			if _midi_key:
				_midi_key.call_key(_event.velocity, _event.message)
				#print_midi_event_properties(event)

func _on_midi_key_pressed(_pitch_letter: String):
	
	note_pressed.emit(_pitch_letter)

func get_key_from_pitch(_pitch: int) -> int:
	
	for _key in pitch_dict:
		if pitch_dict[_key].has(_pitch):
			return _key
	return -1

func print_midi_event_properties(_event: InputEventMIDI) -> void:
	
	printt("Channel: ", _event.channel)
	printt("Pitch: ", _event.pitch)
	printt("Velocity: ", _event.velocity)
	printt("Message: ", _event.message)
	printt("Instrument: ", _event.instrument)
	printt("Pressure: ", _event.pressure)
	print("-------------------")
