extends CharacterBody2D


@export var SPEED = 200.0
var spawn_pos : Vector2

func _ready():
	global_position = spawn_pos

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().health_system()
		area.get_parent().hurt_effect()

func _physics_process(delta):
	velocity = Vector2(-SPEED,0)
	move_and_slide()
