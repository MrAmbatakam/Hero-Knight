extends Node2D
@onready var player = $Player
@onready var collision_shape_2d = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Fall_out_the_world():
	if collision_shape_2d == player:
		get_tree().reload_current_scene()

#func _on_area_2d_area_entered(area):
	#if area.is_in_group("Player"):
		#get_tree().reload_current_scene()
