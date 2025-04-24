extends CharacterBody2D
class_name Enemy

var enemy_health = 6
@onready var health_bar = $HealthBar
@onready var enemy_animated_sprite : AnimationPlayer = $AnimationPlayer
@onready var raycast_detection : RayCast2D = $RayCast2D
#Timers
@onready var chase_timer : Timer = $Timers/Chase_timer
@onready var idle_timer = $Timers/Idle_timer
@onready var idle_cd_timer = $Timers/Idle_Cd_Timer
@onready var attack_timer = $Timers/Attack_timer
@onready var attack_cd_timer = $Timers/Attack_Cd_timer
#RayCasts
@onready var ground_right_ray_cast = $GroundDetctor/RightRayCast
@onready var ground_left_ray_cast = $GroundDetctor/LeftRayCast
@onready var wall_right_ray_cast = $WallDetctor/RightRayCast
@onready var wall_left_ray_cast = $WallDetctor/LeftRayCast
@onready var area2d_right_ray_cast = $Area2DDetctor/RightRayCast
@onready var area2d_left_ray_cast = $Area2DDetctor/LeftRayCast
#Reference
@onready var player = null
@onready var void_area = $"../../VoidArea"
@onready var target = $"../Player"
@onready var detection_collision_shape_2d = $DetectionArea/DetectionCollisionShape2D
@onready var attack_collision_shape_2d = $AttackArea/CollisionShape2D
@onready var attack_box = $CloseEnemy_AttackBox/CollisionPolygon2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
#Enemy State Variables
var is_chase : bool = false
var is_wander : bool = false
var is_idle : bool = false
var is_attack : bool = false
var can_attack : bool = true
#Physics/Logic Variables
var chase_speed = 120
var wander_speed = 40
var direction = 1
var dir = 1
var idle_timer_start = false
var wander_left = false
var wander_right = false
var enemy_moveset : int = 0
var attack_type : int = 0
var attack_cap : int = 0
var keep_attack = false
#@export var start_moving_direction : Vector2 = Vector2.LEFT

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

func _ready():
	health_bar.value = enemy_health
	$CloseEnemy_AttackBox.set_collision_layer_value(2, true)
	$CloseEnemy_AttackBox.set_collision_mask_value(4, true)
	idle_timer.start()
	is_wander = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Handle Wander
	if is_wander:
		#if idle_timer_start == false:
			#idle_timer.start()
			#idle_timer_start = true
		if !ground_right_ray_cast.is_colliding() or wall_right_ray_cast.is_colliding():
			direction = -1
		if !ground_left_ray_cast.is_colliding() or wall_left_ray_cast.is_colliding():
			direction = 1
		velocity.x = direction * wander_speed
	
	#Handle Idle
	if is_idle:
		idle_timer.start()
		velocity.x = 0
		is_wander = false
	
	#Handle Chase
	if is_chase:
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			var player = players[0]
			var pos = (player.position - position).normalized()
			velocity.x = pos.x * chase_speed
			detection_collision_shape_2d.disabled = false
			is_wander = false
			is_idle = false
			if area2d_right_ray_cast.is_colliding() or area2d_left_ray_cast.is_colliding():
				is_wander = true
				is_chase = false
			##var right_collider = area2d_right_ray_cast.get_collider()
			##var left_collider = area2d_right_ray_cast.get_collider()
			##if right_collider is Area2D:
	#else:
		#is_chase = false
		#is_wander = true
	
	#Handle Attack
	if is_attack:
		#var enemy_moveset = randi_range(0,2)
		velocity.x = 0
		is_idle = false
		is_wander = false
		detection_collision_shape_2d.disabled = true
	
	#Handle Flip
	if velocity.x > 0:
		detection_collision_shape_2d.position.x = 80
		attack_collision_shape_2d.position.x = 10
		attack_box.scale.x = 1
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		detection_collision_shape_2d.position.x = -80
		attack_collision_shape_2d.position.x = -10
		attack_box.scale.x = -1
		$Sprite2D.flip_h = true
	
	update_enemy_animation()
	move_and_slide()

################################ ANIMATION CENTER #############################################
func update_enemy_animation():
	if is_idle:
		enemy_animated_sprite.play("Idle")
	if is_wander:
		enemy_animated_sprite.play("Wander")
	if is_chase:
		enemy_animated_sprite.play("Chase")
	if is_attack:
		if attack_type == 0:
			enemy_animated_sprite.play("Attack1")
		if attack_type == 1:
			enemy_animated_sprite.play("Attack2")
	if is_dead:
		enemy_animated_sprite.play("Death")

func _on_animation_player_animation_finished(anim_name):
	if keep_attack == false:
		if attack_cap == 1 and anim_name == "Attack1" or "Attack2":
			is_attack = true
			is_chase = false
			attack_cap = 0
		if attack_cap == 0 and anim_name == "Attack1" or "Attack2":
			is_attack = false
			is_chase = true
	if anim_name == "Death":
		queue_free()

func attackbox_damage():
	attack_box = 1

func dead():
	is_attack = false
	is_chase = false
	is_idle = false
	is_wander = false
	is_dead = true
	$Timers/Attack_timer.stop()
	$Timers/Attack_Cd_timer.stop()
	$Timers/Idle_timer.stop()
	$Timers/Idle_Cd_Timer.stop()
	$WallDetctor/RightRayCast.set_deferred("collision_mask", false)
	$WallDetctor/LeftRayCast.set_deferred("collision_mask", false)
	$Area2DDetctor/LeftRayCast.set_deferred("collision_mask", false)
	$Area2DDetctor/RightRayCast.set_deferred("collision_mask", false)
	$Area2DDetctor/LeftRayCast.set_deferred("collision_mask", false)
	$Area2DDetctor/RightRayCast.set_deferred("collision_mask", false)
	$CloseEnemy_AttackBox/CollisionPolygon2D.set_deferred("disabled", true)
	$AttackArea/CollisionShape2D.set_deferred("disabled", true)
	$CloseEnemy_Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$DetectionArea/DetectionCollisionShape2D.set_deferred("disabled", true)
	set_collision_mask_value(1, false) #Change Mask So player can't collide it
	set_collision_layer_value(2, false) #Disable 1 so player cant push it
	set_collision_mask_value(8, true) #set it to corpse collision mask

func enemy_health_system():
	enemy_health -= 1
	health_bar.value = enemy_health
	print(enemy_health)
	if enemy_health > 0 and is_wander:
		is_chase = true
		is_wander = false
	if enemy_health <= 0:
		velocity = Vector2.ZERO
		dead()

################################ SIGNAL CENTER #############################################
#Player Detection
func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		is_chase = true
		is_wander = false
		chase_timer.stop()
func _on_detect_player_body_exited(body):
	if body.is_in_group("Player"):
		chase_timer.start()

#Attack Detection
func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		keep_attack = true
		var enemy_moveset = randi_range(0,1) #Random moveset
		if enemy_moveset == 0:
			attack_type = 0
		if enemy_moveset == 1:
			attack_type = 1
			
		is_attack = true
		is_chase = false
		is_wander = false
		is_idle = false
		chase_timer.stop()
		idle_timer.stop()

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		idle_timer.start()
		chase_timer.start()
		keep_attack = false
		attack_cap = 1
		if attack_cap == 0:
			is_attack = false
			is_chase = true

#HitBox
func _on_attack_box_area_entered(area):
	if area.is_in_group("Player_hitbox"):
		pass
func _on_close_enemy_hitbox_area_entered(area):
	if is_dead:
		return
	if area.is_in_group("Player_Attackbox1") or area.is_in_group("Player_Attackbox2"):
		$hit_sfx.play()
		enemy_health_system()
		$Sprite2D.modulate = Color(100,100,100)
		$Timers/OuchFlash_Timer.start()

################################ TIMER CENTER #############################################
func _on_chase_timer_timeout():
	print("chase timer")
	chase_timer.stop()
	is_chase = false
	is_wander = true

func _on_idle_timer_timeout():
	#print("idle timer")
	idle_cd_timer.start()
	idle_timer.stop()
	is_idle = true
	is_wander = false
func _on_idle_cd_timer_timeout():
	idle_cd_timer.stop()
	is_idle = false
	is_wander = true
	#idle_timer_start = false

func _on_attack_timer_timeout():
	is_attack = false
	is_chase = true
	attack_timer.stop()
	attack_box.disabled = true
	detection_collision_shape_2d.disabled = false
func _on_attack_cd_timer_timeout():
	can_attack = true
	attack_cd_timer.stop()
	
func _on_ouch_flash_timer_timeout():
	$Sprite2D.modulate = Color(1,1,1)

#func _on_animation_player_animation_finished(anim_name):
	#if keep_attack == false:
		#if attack_cap == 1 and anim_name == "Attack1" or "Attack2":
			#is_attack = true
			#is_chase = false
			#attack_cap = 0
		#if attack_cap == 0 and anim_name == "Attack1" or "Attack2":
			#is_attack = false
			#is_chase = true
