extends KinematicBody2D

export (int) var speed = 100
export (float) var rotation_speed = 2.5

var velocity = Vector2()
var rotation_dir = 0

export var bullet_speed = 400
export var fire_delay = 2

var projectile = load("res://scene_resources/Projectile.tscn")

var pos_x = 1150
var pos1_y = 200
var pos2_y = 620

var score_time_start
var motor_input = 0
var rotation_input = 0 
var fire_input = 0

func _ready():
	score_time_start = OS.get_unix_time()
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	rotation_input = json.result["r"]
	motor_input = json.result["m"]
	fire_input = json.result["f"]
	
func get_input():
	rotation_dir = 0
	velocity = Vector2()
	if rotation_input == 1:
		rotation_dir += 1
	if rotation_input == -1:
		rotation_dir -= 1
	if motor_input == -1:
		velocity = Vector2(-speed, 0).rotated(rotation)
	if motor_input == 1:
		velocity = Vector2(speed, 0).rotated(rotation)
	if (fire_input == 1) and Global.TeamBCanFire:
		shoot()
		Global.TeamBCanFire = false
		yield(get_tree().create_timer(fire_delay), "timeout")
		Global.TeamBCanFire = true
		
func _process(delta):
	$HTTPRequest.request("http://127.0.0.1:5000")
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
						m_child.set_global_position(Vector2(100, 200))
					if "TankB" in m_child.name:
						m_child.set_global_position(Vector2(1150, 200))
					if ("teamAscore" in m_child.name) and ((OS.get_unix_time()-score_time_start) >= 1):
						Global.TeamAScore += 1
						m_child.text = str(Global.TeamAScore)
						score_time_start = OS.get_unix_time()


func shoot():
	var bullet = projectile.instance()
	bullet.position = get_child(2).get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet)
