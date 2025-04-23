extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var transition = $"Transition UI/Transition"

func _ready():
	transition.play("Fade_In")
	$AudioStreamPlayer.play()
	polygon_2d.polygon = collision_polygon_2d.polygon

func _enter_tree():
	if Checkpoint.last_position:
		$Player.global_position = Checkpoint.last_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
