extends Control

@onready var pause_menu = $"."
@onready var click_sfx = $Click_sfx
@onready var select_sfx = $Select_sfx
var paused = false

func _ready():
	pause_menu.hide()

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		var game_over = get_tree().get_first_node_in_group("Game_Over")
		if game_over and game_over.visible:
			return
		select_sfx.play()
		handle_pause()
		print("pause")

func handle_pause():
	if paused:
		paused = false
		pause_menu.hide()
		get_tree().paused = false
	else:
		paused = true
		pause_menu.show()
		get_tree().paused = true
	
	#paused = !paused

#Fullscreen Button
func _on_full_screen_pressed():
	click_sfx.play()
	if Global.fullscreen_count == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Global.fullscreen_count = 1
	elif Global.fullscreen_count == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.fullscreen_count = 0
func _on_full_screen_mouse_entered():
	select_sfx.play()

#LeaveGame Button
func _on_leave_game_pressed():
	click_sfx.play()
	$Transition.play("Fade_Out")
func _on_leave_game_mouse_entered():
	select_sfx.play()
func _on_transition_animation_finished(anim_name):
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Levels/main_menu.tscn")

#Volume Button
func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
