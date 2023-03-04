extends Area2D
class_name Bullet

onready var kill_timer = $KillTimer

export (int) var speed = 10

var direction := Vector2.ZERO
var team: Team = null

func _ready() -> void:
	kill_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity


func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	if is_instance_valid(body) and is_instance_valid(team) and body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team().team != team.team:
			body.handle_hit()
		queue_free()
