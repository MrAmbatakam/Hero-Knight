extends State
class_name Idle

func _ready():
	pass
#
#@export var enemy : CharacterBody2D
#@export var speed := 30
#
#var move_direction_left : Vector2
##var move_direction_right : Vector2 = Vector2.RIGHT
#var wander_time : float
#
## wandering
#func random_wander():
	#move_direction_left = Vector2(randf_range(5,5), randf_range(0,0)).normalized() #set wander move direction
	##move_direction_right = Vector2(randf_range(-1,0), randf_range(3,0))
	#wander_time = randf_range(1,5) # 
#
##calling from the state script
#func enter():
	#random_wander()
	#
#func update(delta: float):
	#if wander_time > 0:
		#wander_time -= delta
	#else:
		#random_wander()
	#
#func physics_update(delta: float):
	#if enemy:
		#enemy.velocity = move_direction_left * speed
