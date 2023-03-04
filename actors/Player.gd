extends KinematicBody2D
class_name Player

export (int) var speed = 150
var run_modifier

onready var weapon : Weapon = $Weapon
onready var team = $Team
onready var health_stat = $Health

func _ready() -> void:
	weapon.initialize(team)
	weapon.connect("weapon_out_of_ammo", self, "reload")

func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	
	var actualspeed = speed
	if Input.is_action_pressed("run"):
		run_modifier += 3
		actualspeed = speed + run_modifier
	else:
		run_modifier = 0
	
	if actualspeed > 300:
		actualspeed = 300

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * actualspeed)

	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		weapon.shoot()
	elif event.is_action_pressed("reload"):
		weapon.start_reload()

func reload():
	weapon.start_reload()

func get_team() -> Team:
	return team

func handle_hit():
	health_stat.health -= 20
	print("player hit ", health_stat.health)
