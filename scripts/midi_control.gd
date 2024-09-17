extends Control

# NOTE: Set the size of this array to 12 and assign each index a midi_key node
# containing a midi_key script. Ideally, this array should contain one of every
# key from C to B.
@export var midi_keys: Array[Node]

# Called when the node enters the scene tree for the first time.
# Opens MIDI inputs and prints the connected MIDI controller.
func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

# Called whenever an input is sensed.
# If a keyboard key is pressed or released,
# call check_key in every midi_key object inside of midi_keys.
func _input(event):
	if event is InputEventMIDI:
		if event.message == 9 or event.message == 8:
			for piano_key in midi_keys:
				piano_key.call_key(event.pitch, event.velocity)
				
			#print("MIDI BUTTON CALLED.")
			#printt("Channel: ", event.channel)			# MIDI channel (0-15)
			printt("Pitch: ", event.pitch)				# MIDI note number (0-127)
			printt("Velocity: ", event.velocity)			# MIDI note velocity (0-127)
			printt("Message: ", event.message)			# MIDI signal
			#printt("Instrument: ", event.instrument)		# MIDI instrument (0-127)
			#printt("Pressure: ", event.pressure)			# MIDI signal pressure (0-127)
			print("-------------------")
			
