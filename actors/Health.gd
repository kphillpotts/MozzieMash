extends Node2D

export (int) var max_health = 100
export (int) var health = 100 setget set_health

func set_health(new_health: int):
	health = clamp(new_health, 0, max_health)
