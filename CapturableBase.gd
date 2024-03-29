extends Area2D

signal base_captured_by_new_team

export (Color) var player_color = Color(0, 1, 0)
export (Color) var enemy_color = Color(1,0,0)
export (Color) var neutral_color = Color(1,1,1)

var player_unit_count: int  = 0
var enemy_unit_count: int = 0
var team_to_capture: int = Team.TeamName.NEUTRAL

onready var team = $Team
onready var capture_timer = $CaptureTimer
onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_CapturableBase_body_entered(body: Node) -> void:
	if (body.has_method("get_team")):
		var body_team = body.get_team()
		
		if body_team.team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
		elif body_team.team  == Team.TeamName.PLAYER:
			player_unit_count += 1
		
		check_whether_base_can_be_captured()


func _on_CapturableBase_body_exited(body: Node) -> void:
	if (body.has_method("get_team")):
		var body_team = body.get_team()
		if body_team.team  == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
		elif body_team.team  == Team.TeamName.PLAYER:
			player_unit_count -= 1

func check_whether_base_can_be_captured():
	var majority_team = get_team_with_majority()
	
	if majority_team == Team.TeamName.NEUTRAL:
		return
	elif majority_team == team.team:
		print("Owning team regained majority, stoping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		print("New team has majority in base, starting capture clock")
		team_to_capture = majority_team
		capture_timer.start()
		
	
		
		
		
func get_team_with_majority() -> int:
	if enemy_unit_count == player_unit_count:
		return Team.TeamName.NEUTRAL
	elif player_unit_count > enemy_unit_count:
		return Team.TeamName.PLAYER
	else:
		return Team.TeamName.ENEMY

func set_team(new_team: int):
	team.team = new_team
	emit_signal("base_captured", new_team)
	match new_team:
		Team.TeamName.NEUTRAL:
			sprite.modulate = neutral_color
			return
		Team.TeamName.PLAYER:
			sprite.modulate = player_color
			return
		Team.TeamName.ENEMY:
			sprite.modulate = enemy_color
			return

func _on_CaptureTimer_timeout() -> void:
	set_team(team_to_capture)
