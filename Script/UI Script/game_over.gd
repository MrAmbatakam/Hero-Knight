extends Control
#
#var can_pause = false
#
func _ready():
	pass
	#self.hide()
	#add_to_group("Game_Over")
#
func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
#
#func _on_leave_pressed():
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://Scene/Levels/main_menu.tscn")
#
func game_over():
	get_tree().paused = true
	self.show()
	#$GameOverMusic.play()
