extends Control

@onready var transition = $Transition
@onready var intro_animation = $Intro_Animation

func _ready():
	$CenterContainer/Page3/Label.visible = false
	$Page2_Art.visible = false
	$Page3_Art.visible = false
	$Page4_Art.visible = false
	$Page5_Art.visible = false
	$Page6_Art.visible = false
	transition.play("Fade_In")

func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		transition.play("Fade_Out")

func _on_intro_animation_animation_finished(anim_name):
	transition.play("Fade_Out")

func _on_transition_animation_finished(anim_name):
	if anim_name == "Fade_In":
		$Intro_Music.play()
		intro_animation.play("Intro_Cutscene")
	if anim_name == "Fade_Out":
		#if not Checkpoint.last_scene: #AI
		#Later
		if Checkpoint.last_scene and Checkpoint.last_position: #AI
		# Load the level where checkpoint was saved
			get_tree().change_scene_to_file(Checkpoint.last_scene)
		else:
			get_tree().change_scene_to_file("res://Scene/Levels/tutorial.tscn")
