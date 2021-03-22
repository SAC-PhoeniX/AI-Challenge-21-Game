extends Label

var time_start
var time_now
var time_elapsed
var time_remaining = 120
var game_time = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = OS.get_unix_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = OS.get_unix_time()
	time_elapsed = time_now - time_start
	time_remaining = game_time - time_elapsed
	self.text = str(time_remaining)

	if time_remaining < 1:
		get_tree().change_scene("res://GameOver.tscn")

