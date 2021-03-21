extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	yield(get_tree().create_timer(6), "timeout")
	queue_free()
