extends Node2D

func handle_bullet_spawned(bullet : Bullet, team : Team, position : Vector2, direction : Vector2): 
	add_child(bullet)
	bullet.global_position = position
	bullet.team = team
	bullet.set_direction(direction)
