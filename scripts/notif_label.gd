class_name NotifLabel extends Label

## VARIABLES

var countdown_texts := ["3", "2", "1", "START!"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_game_countdown():
	show()
	
	for i in range(4):
		text = "Press the KEYS that match the ASTEROIDS!\n" + str(countdown_texts[i])
		await(get_tree().create_timer(1, false).timeout)
		
	text = ""
	hide()

func test_func():
	print("Works!")
