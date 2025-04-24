extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/Levels/main_menu.tscn")
func _on_button_mouse_entered():
	$Select_sfx.play()
