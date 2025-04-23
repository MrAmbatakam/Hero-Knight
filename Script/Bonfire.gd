extends Area2D

var trigger = false

func _ready():
	$Checkpoint_Animation.play("Bonfire")

func _on_body_entered(body):
	if trigger == false:
		trigger = true
		Checkpoint.last_position = global_position
		Checkpoint.last_scene = get_tree().current_scene.scene_file_path
		print("enter")
		$Checkpoint_Sprite.modulate = Color(0,1,10)
		$Bonfire_sfx.play()
		var player = body
		player.reset_health()

#func restore_player_health(player):
	# Calculate how much health to add (up to max of 5)
	#var health_to_add = min(5 - player.player_health, 3)  # Restores up to 3 health
	
	#if health_to_add > 0:
		#player.player_health += health_to_add
		# Update health UI - assuming each health point is 16 pixels wide
		#player.health_ui += 16 * health_to_add


func _on_timer_timeout():
	pass
