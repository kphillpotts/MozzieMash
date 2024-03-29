extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}


onready var player_detection_zone = $DetectionZone
onready var patrol_timer = $PatrolTimer


var current_state = -1 setget set_state
var target : KinematicBody2D = null
var weapon : Weapon = null
var actor : KinematicBody2D = null
var team : Team = null

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_state(State.PATROL)
	


func _process(delta: float) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				actor.rotate_toward(patrol_location)
				actor.rotation = lerp(actor.rotation, actor.global_position.direction_to(patrol_location).angle(), 0.1)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
				
		State.ENGAGE:
			if target != null and weapon != null:
				var angle_to_player = actor.global_position.direction_to(target.global_position).angle()
				actor.rotate_toward(target.global_position)
				if (abs(actor.rotation - angle_to_player)) < 0.1:
					weapon.shoot()
			else:
				print ("In the engaged state but no weapon or player")
		_:
			print ("Error: found a state for our enemy that should not exist")


func initialize(actor : KinematicBody2D, weapon : Weapon, team : Team):
	self.actor = actor
	self.weapon = weapon
	self.team = team
	self.weapon.connect("weapon_out_of_ammo", self, "handle_reload")

func set_state(new_state: int):
	if new_state == current_state:
		return
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	current_state = new_state
	emit_signal("state_changed", current_state)

func handle_reload():
	weapon.start_reload()


func _on_PatrolTimer_timeout() -> void:
	
	var viewportInfo = get_viewport().get_visible_rect()
	var myposition = origin
	var minx = myposition.x - viewportInfo.position.x
	var maxx = viewportInfo.end.x - myposition.x
	var miny = myposition.y - viewportInfo.position.y
	var maxy = viewportInfo.end.y - myposition.y
	var random_x = rand_range(viewportInfo.position.x + 50, viewportInfo.end.x - 50)
	var random_y = rand_range(viewportInfo.position.y + 50, viewportInfo.end.y - 50)
	
	patrol_location = Vector2(random_x, random_y)
	#var random_y = rand_range(miny, maxy)
	print ("patrol location set ", random_x)
	print ("patrol y ", random_y)
	var partrol_range = 100
#	var random_x = rand_range(-partrol_range, partrol_range)
#	var random_y = rand_range(-partrol_range, partrol_range)
	#patrol_location = Vector2(random_x, random_y) + origin
	
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)


func _on_DetectionZone_body_entered(body: Node) -> void:
	if body.has_method("get_team") and body.get_team().team != team.team :
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target:
		set_state(State.PATROL)
		target = null
