extends Node2D

@onready var arrow = preload("res://Scene/Traps Scene/arrow.tscn")
@onready var cooldown = $Cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow_anim()

func arrow_anim():
	$AnimationPlayer.play("ArrowTrap")

func shoot_arrow():
	var instance_arrow = arrow.instantiate()
	instance_arrow.spawn_pos = global_position
	add_child(instance_arrow)

func _on_cooldown_timeout():
	arrow_anim()
