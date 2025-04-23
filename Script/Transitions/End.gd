extends Sprite2D

@onready var portal_transition = $"../Portal_Transition"

func _ready():
	$AnimationPlayer.play("Portal")

func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_hitbox"):
		portal_transition.play("Portal_FadeOut")

func _on_portal_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scene/world.tscn")


func _on_transition_animation_finished(anim_name):
	#if anim_name == "Fade_Out":
		#get_tree().change_scene_to_file("res://Scene/world.tscn")
	pass
