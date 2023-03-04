extends Node2D

class_name Team

enum TeamName {
	PLAYER,
	ENEMY
}

export (TeamName) var team = TeamName.PLAYER
