extends KinematicBody2D

export (int) var speed = 100
export (float) var rotation_speed = 2.5

var velocity = Vector2()
var rotation_dir = 0

export var bullet_speed = 400
export var fire_delay = 2

var projectile = load("res://Projectile.tscn")
var can_fire = true

var pos_x = 100
var pos1_y = 200
var pos2_y = 620

func get_input():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		rotation_dir += 1
	if Input.is_action_pressed('ui_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('ui_down'):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_up'):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("ui_select") and can_fire:
		shoot()
		can_fire = false
		yield(get_tree().create_timer(fire_delay), "timeout")
		can_fire = true
		
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
						m_child.set_global_position(Vector2(100, 200))
					if "TankB" in m_child.name:
						m_child.set_global_position(Vector2(1150, 200))
					if ("teamBscore" in m_child.name):
						m_child.text = str(int(m_child.text)+1)


func shoot():
	var bullet = projectile.instance()
	bullet.position = get_child(2).get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet)
