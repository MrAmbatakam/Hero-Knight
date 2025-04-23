extends Control

@onready var select_sfx = $Select_Sfx
@onready var click_sfx = $Click_Sfx

func _ready():
	$MainMenu_Music.play()

############################# START GAME ######################################
func _on_start_pressed():
	click_sfx.play()
	$Transition.play("Fade_Out")
func _on_start_mouse_entered():
	select_sfx.play()

############################# SETTING MENU ######################################
func _on_settings_pressed():
	click_sfx.play()
	$TextureRect.visible = false
	$CenterContainer/MainButtons.visible = false
	$SettingMenuButtons.visible = true
	$SettingMenuVolumeBar.visible = true
func _on_settings_mouse_entered():
	select_sfx.play()

func _on_fullscreen_pressed():
	click_sfx.play()
	if Global.fullscreen_count == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Global.fullscreen_count = 1
	elif Global.fullscreen_count == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.fullscreen_count = 0
func _on_fullscreen_mouse_entered():
	select_sfx.play()

############################# CREDITS MENU ######################################
func _on_credits_pressed():
	click_sfx.play()
	$TextureRect.visible = false
	$CenterContainer/MainButtons.visible = false
	$CreditsMenu1.visible = true
func _on_credits_mouse_entered():
	select_sfx.play()

func _on_more_pressed():
	click_sfx.play()
	$CreditsMenu1.visible = false
	$CreditsMenu2.visible = true
func _on_more_mouse_entered():
	select_sfx.play()

func _on_back_pressed():
	click_sfx.play()
	$CreditsMenu1.visible = true
	$CreditsMenu2.visible = false
func _on_back_mouse_entered():
	select_sfx.play()

##################################################################################

func _on_quit_pressed():
	click_sfx.play()
	get_tree().quit()
func _on_quit_mouse_entered():
	select_sfx.play()

func _on_return_pressed():
	click_sfx.play()
	$TextureRect.visible = true
	$CenterContainer/MainButtons.visible = true
	$SettingMenuButtons.visible = false
	$SettingMenuVolumeBar.visible = false
	$CreditsMenu1.visible = false
	$CreditsMenu2.visible = false
func _on_return_mouse_entered():
	select_sfx.play()

func _on_v_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	Global.volume_slider = $SettingMenuVolumeBar/VSlider.value

func _on_transition_animation_finished(anim_name):
	#if Checkpoint.last_scene and Checkpoint.last_position: #AI
		# Load the level where checkpoint was saved
		#get_tree().change_scene_to_file(Checkpoint.last_scene)
	#else:
	get_tree().change_scene_to_file("res://Scene/Levels/intro.tscn")
