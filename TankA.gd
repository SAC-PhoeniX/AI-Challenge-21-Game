extends KinematicBody2D

export (int) var speed = 100
export (float) var rotation_speed = 2.5

var velocity = Vector2()
var rotation_dir = 0

export var bullet_speed = 400
export var fire_delay = 2

var projectile = load("res://Projectile.tscn")
var can_fire = true

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
	velocity = move_and_slide(velocity)

func shoot():
	var bullet = projectile.instance()
	bullet.position = get_child(2).get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet)
