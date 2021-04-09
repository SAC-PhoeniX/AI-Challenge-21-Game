extends KinematicBody2D

export (int) var speed = 100
export (float) var rotation_speed = 2.5

var velocity = Vector2()
var rotation_dir = 0

export var bullet_speed = 400
export var fire_delay = 2

var projectile = load("res://scene_resources/Projectile.tscn")

var pos1_y = 200
var pos2_y = 620
var rng = RandomNumberGenerator.new()

var score_time_start

func _ready():
	score_time_start = OS.get_unix_time()


func get_input():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		rotation_dir += 1
	if Input.is_action_pressed('ui_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('ui_up'):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_down'):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if (Input.is_action_pressed("ui_select")) and Global.TeamACanFire:
		shoot()
		Global.TeamACanFire = false
		yield(get_tree().create_timer(fire_delay), "timeout")
		Global.TeamACanFire = true
		
func _process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Projectile" in collision.collider.name:
			for child in get_tree().get_root().get_children():
				if "Projectile" in child.name:
					child.queue_free()
				for m_child in child.get_children():
					if "TankA" in m_child.name:
						rng.randomize()
						var my_random_number = rng.randi_range(0, 1)
						if my_random_number == 0:
							m_child.set_global_position(Vector2(100, pos1_y))
						else:
							m_child.set_global_position(Vector2(100, pos2_y))
					if "TankB" in m_child.name:
						rng.randomize()
						var my_random_number = rng.randi_range(0, 1)
						if my_random_number == 0:
							m_child.set_global_position(Vector2(1150, pos1_y))
						else:
							m_child.set_global_position(Vector2(1150, pos2_y))
					if ("teamBscore" in m_child.name) and ((OS.get_unix_time()-score_time_start) >= 1):
						Global.TeamBScore += 1
						m_child.text = str(Global.TeamBScore)
						score_time_start = OS.get_unix_time()


func shoot():
	var bullet = projectile.instance()
	bullet.position = get_child(2).get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet)
