extends Node2D

func _ready():
	$AnimationPlayer.play("Moving_Saw")

func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().health_system()
		area.get_parent().hurt_effect()
