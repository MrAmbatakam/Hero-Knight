extends Control

@onready var transition = $Transition
@onready var click_sfx = $Click_sfx
@onready var select_sfx = $Select_sfx

func _ready():
	self.hide()
	add_to_group("Game_Over")


func _on_retry_pressed():
	click_sfx.play()
	get_tree().paused = false
func _on_click_sfx_finished():
	get_tree().reload_current_scene()
func _on_retry_mouse_entered():
	select_sfx.play()

func _on_leave_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Levels/main_menu.tscn")
func _on_leave_mouse_entered():
	select_sfx.play()

func game_over_transition():
	get_tree().paused = true
	self.show()
	$GameOverMusic.play()

func _on_transition_animation_finished(anim_name):
	#$GameOverMusic.play()
	pass
