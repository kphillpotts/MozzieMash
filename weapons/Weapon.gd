extends Node2D
class_name Weapon

signal weapon_out_of_ammo

export (PackedScene) var Bullet

var team : Team = null
var max_ammo: int = 6
var current_ammo: int = max_ammo

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunCatDirection
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer
onready var muzzle_flash = $MuzzleFlash

func _ready() -> void:
	muzzle_flash.hide()

func initialize(team : Team):
	self.team = team


func shoot():
	if current_ammo != 0 and attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, team, end_of_gun.global_position, direction)
		attack_cooldown.start()
		animation_player.play("MuzzleFlash")
		current_ammo -= 1
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")

func start_reload():
	animation_player.play("reload")
	
func _stop_reload():
	current_ammo = max_ammo
