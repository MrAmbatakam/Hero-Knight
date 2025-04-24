extends Node2D

@onready var cooldown = $Cooldown

func _ready():
	shoot_fire()

func shoot_fire():
	$AnimationPlayer.play("FireTrap")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().health_system()
		area.get_parent().hurt_effect()

func _on_animation_player_animation_finished(anim_name):
	cooldown.start()

func _on_cooldown_timeout():
	shoot_fire()
