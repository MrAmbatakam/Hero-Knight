class_name Homing_Fireball
extends Area2D

#var fireball_volume = 10
@onready var animation_player = $AnimationPlayer
@onready var fire_sfx = $fire_sfx
@onready var enemy = get_tree().get_nodes_in_group("RangeEnemy")
@onready var player = get_tree().get_nodes_in_group("Player")
var fireball_speed = 100
var target_enemy: Node2D = null
var deflected = false
var current_target: Node2D = null
var deflecting_enemy: Node2D = null

func _ready():
	animation_player.play("Fireball")
	$fire_sfx.play()
	set_collision_layer_value(1, true)  # Player projectiles
	set_collision_mask_value(1, true)   # Can hit deflect areas
	set_collision_mask_value(3, true)
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		current_target = players[0]

func _physics_process(delta):
	#Homing Logic
	if not is_instance_valid(current_target):
		queue_free()
		return
	var direction = (current_target.global_position - global_position).normalized()
	position += direction * fireball_speed * delta
	look_at(current_target.global_position)

func deflect_freeze_effect():
	Engine.time_scale = 0.5
	$Freeze_Timer.start()
func deflect_color_effect():
	player[0].modulate = Color(10, 10, 10)
	$Flash_Timer.start()

func handle_deflection(area, new_target_group):
	#deflection_count += 1
	#if deflection_count > MAX_DEFLECTIONS:
		#queue_free()
		#return
	fireball_speed += 5
	# Find new target
	var targets = get_tree().get_nodes_in_group(new_target_group)
	if targets.size() > 0:
		current_target = targets[0]
	
	if new_target_group == "RangeEnemy":
		deflected = true
		set_collision_layer_value(1, false)  # No longer player projectile
		set_collision_layer_value(2, true)   # Now enemy projectile
		set_collision_mask_value(1, false)   # Don't hit player
		set_collision_mask_value(2, true)
		$parry_sfx.pitch_scale = randf_range(0.9, 1.1)
		$parry_sfx.play()
		fire_sfx.stop()
		deflect_freeze_effect()
		deflect_color_effect()
	else:
		deflected = false
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		$enemy_parry_sfx.pitch_scale = randf_range(0.9, 1.1)
		$enemy_parry_sfx.play()
		fire_sfx.play()

	# Effects
	#$parry_sfx.pitch_scale = randf_range(0.9, 1.1)
	#$parry_sfx.play()
	$Sprite2D.modulate = Color(2, 2, 2) if deflected else Color(1, 1, 1)

func _on_area_entered(area):
	if area.is_in_group("Player_hitbox") and !deflected:
		if is_instance_valid(current_target):
			Global.fireball_count -= 1
			current_target.health_system()
			current_target.hurt_effect()
		queue_free()
	if area.is_in_group("RangeEnemy_HitBox") and deflected:
		Global.fireball_count -= 1
		queue_free()
		var hit_enemy = area.get_parent()
		if is_instance_valid(hit_enemy) and hit_enemy.is_in_group("RangeEnemy"):
			hit_enemy.range_enemy_health_system()
			hit_enemy.range_enemy_ouch_effect()
		#var enemy = area.get_parent()
		#if enemy.is_deflect:
			#queue_free()
		#else:
			#queue_free()
	
	if area.is_in_group("DeflectBox") and !deflected:
		# Find all living enemies
		handle_deflection(area, "RangeEnemy")
		var living_enemies = []
		for enemy in get_tree().get_nodes_in_group("RangeEnemy"):
			if is_instance_valid(enemy):
				living_enemies.append(enemy)
		
		if living_enemies.size() > 0:
			# Target the closest living enemy
			var closest_enemy = living_enemies[0]
			var closest_distance = global_position.distance_to(closest_enemy.global_position)
			
			for enemy in living_enemies:
				var dist = global_position.distance_to(enemy.global_position)
				if dist < closest_distance:
					closest_distance = dist
					closest_enemy = enemy
			
			#deflecting_enemy = closest_enemy
			current_target = closest_enemy

	if area.is_in_group("EnemyDeflectBox"):
		handle_deflection(area, "Player")
		#fireball_speed += 5
		#deflected = false
		#$Sprite2D.modulate = Color(1, 1, 1)
		#set_collision_mask_value(1, true)
		#set_collision_mask_value(2, false)
		#set_collision_mask_value(1, true)
		#set_collision_mask_value(2, false)

#Loop Fireball Sfx
func _on_fire_sfx_finished():
	$fire_sfx.play()

func _on_freeze_timer_timeout():
	Engine.time_scale = 1.0
func _on_flash_timer_timeout():
	player[0].modulate = Color(1, 1, 1)


	#var target = get_tree().get_nodes_in_group("Player")
	#var target_pos = target[0].global_position
	#var direction = (target_pos - global_position).normalized()
	#position += direction * fireball_speed * delta  
	#look_at(target_pos)
	pass

#var fireball_speed = 150
##var target
#@onready var animation_player = $AnimationPlayer
#@export var target : Player #(fail attempt)
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#animation_player.play("Fireball")
	#for node in get_tree().get_nodes_in_group("Player"):
		#target = node
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
	#if target:
		#var target_pos = target.global_position
		#look_at(target.global_position)
		#position += transform.x * fireball_speed * delta
		##position = position.move_toward(target_pos, fireball_speed * delta) (fail attempt)
#
#func _on_area_entered(area):
	#if area.is_in_group("Player_hitbox"):
		#target.health_system()
		#target.hurt_effect()
		#queue_free()
