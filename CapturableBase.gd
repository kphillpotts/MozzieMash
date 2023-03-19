extends Area2D


export (Color) var player_color = Color(0, 1, 0)
export (Color) var enemy_color = Color(1,0,0)
export (Color) var neuetral_color = Color(1,1,1)

var player_unit_count = 0
var enemy_unit_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_CapturableBase_body_entered(body: Node) -> void:
	if (body.has_method("get_team")):
		
		pass # Replace with function body.


func _on_CapturableBase_body_exited(body: Node) -> void:
	pass # Replace with function body.
