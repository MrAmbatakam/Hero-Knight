extends Node2D

@onready var arrow = preload("res://Scene/Traps Scene/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("ArrowTrap")

func shoot_arrow():
	var instance_arrow = arrow.instantiate()
	instance_arrow.spawn_pos = global_position
	add_child(instance_arrow)
