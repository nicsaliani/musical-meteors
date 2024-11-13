class_name MidiControl extends Control

## SIGNALS
signal note_pressed

## EXPORT
@export var midi_keys: Array[Node]

## VARIABLES
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
var active_midi_keys: Array[Node] = []
## FUNCTIONS
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	for _midi_key in midi_keys:
		_midi_key.connect("midi_key_pressed", _on_midi_key_pressed)
		update_key_state(_midi_key, true)


func _input(_event):
	if _event is InputEventMIDI:
		if _event.message == 9 or _event.message == 8:
			var _midi_key = midi_keys[get_key_from_pitch(_event.pitch)]
			if _midi_key and _midi_key.is_active():
				_midi_key.call_key(_event.velocity, _event.message)
				#print_midi_event_properties(_event)


func _on_start_game_button_pressed() -> void:
	update_key_state(midi_keys[1], false)
	update_key_state(midi_keys[3], false)
	for i in range (5, len(midi_keys)):
		update_key_state(midi_keys[i], false)


func _on_midi_key_pressed(_pitch_letter: String):
	if GameManager.game_state == GameManager.GameState.PLAYING:
		note_pressed.emit(_pitch_letter)


func get_key_from_pitch(_pitch: int) -> int:
	for _key in pitch_dict:
		if pitch_dict[_key].has(_pitch):
			return _key
	return -1


func update_key_state(_midi_key: Node2D, _state: bool) -> void:
	#print(_midi_key, ", ", _state)
	_midi_key.set_active(_state)
	if _state:
		active_midi_keys.append(_midi_key)
	else:
		if active_midi_keys.has(_midi_key):
			active_midi_keys.erase(_midi_key)


func _on_asteroid_manager_wrong_note_played(pitch: Variant) -> void:
	var _suspended_keys: Array[Node] = []
	
	for _midi_key in active_midi_keys:
		_suspended_keys.append(_midi_key)
	
	for _midi_key in _suspended_keys:
		update_key_state(_midi_key, false)
		
	await get_tree().create_timer(2.0).timeout
	
	for _midi_key in _suspended_keys:
		update_key_state(_midi_key, true)
	
	_suspended_keys.clear()


func print_midi_event_properties(_event: InputEventMIDI) -> void:
	printt("Channel: ", _event.channel)
	printt("Pitch: ", _event.pitch)
	printt("Velocity: ", _event.velocity)
	printt("Message: ", _event.message)
	printt("Instrument: ", _event.instrument)
	printt("Pressure: ", _event.pressure)
	print("-------------------")
