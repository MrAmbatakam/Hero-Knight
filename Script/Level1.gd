extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level1_Music.play()
	$Portal_Transition.play("Portal_FadeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_portal_transition_animation_finished(anim_name):
	#$Level1_Music.play()
	pass


func _on_end_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
