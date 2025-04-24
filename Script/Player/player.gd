class_name Player
extends CharacterBody2D

var player_health = 5
@onready var game_over = $UI/GameOver
const SPEED = 150
const JUMP_VELOCITY = -400
const FALL_GRAVITY = 1000
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
#Sfx
@onready var player_run_sfx = $Sfx/sfx_run
@onready var player_dash_sfx = $Sfx/sfx_dash
@onready var player_jump_sfx = $Sfx/sfx_jump
@onready var player_swing_sfx = $Sfx/sfx_swing

##Timers variables
#Dash Timer
@onready var dash_timer = $Timer/DashTimer
@onready var dash_cooldown_timer = $Timer/DashCooldownTimer
@onready var dash_flash_timer = $Timer/DashFlashTimer
#Game Quality Timer
@onready var coyote_timer = $Timer/CoyoteTimer
@onready var jump_buffer_timer = $Timer/JumpBufferTimer
#Labels/UI
@onready var hearts = $UI/Panel/TextureRect
#Enemy Reference
@onready var enemy = $"../CloseEnemy/Enemy"


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var disable_gravity = false
var finish_jump = false
var is_in_air = false
var player_direction = 0
var invincible_time = false
#Jump Var
var can_jump : bool = false
var jump_buffer : int = 0
var jump_buffer_frames : int = 15
var mario_jump_buffer = false
var is_space_hold = false
#Dash Var
const DASH_SPEED = 200
var can_dash : bool = false
var dash_cooldown : bool = false
var dash_effect_scene = preload("res://Scene/DASH/dash_effect.tscn")
#Attack Var
var is_attack = false
var can_air_attack = true
var attack_string = ""
var attack_cooldown = false
#Deflect variable
var is_deflect = false
var deflect_cooldown = false
#Dead variable
var is_dead = false

func _ready():
	if Checkpoint.last_scene == get_tree().current_scene.scene_file_path and Checkpoint.last_position:
		global_position = Checkpoint.last_position
	$Player_AttackBox1/CollisionPolygon2D.disabled = true
	$Player_AttackBox2/CollisionPolygon2D.disabled = true

func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if !disable_gravity and not is_on_floor():
		velocity.y += gravity * delta
		#jump_buffer_timer.start()

	# Handle jump.
	if is_on_floor() or !coyote_timer.is_stopped(): #Coyote Jump
		if Input.is_action_just_pressed("Space"):
			velocity.y = JUMP_VELOCITY
			mario_jump_buffer = false
			is_space_hold = Input.is_action_pressed("Space")
			is_in_air = false
			player_jump_sfx.play()

	if Input.is_action_just_pressed("Space") and !is_on_floor(): #Jump Buffer
		if !is_in_air:
			jump_buffer = jump_buffer_frames
			mario_jump_buffer = true
			is_in_air = true
	if jump_buffer > 0:
		jump_buffer -= 1
	if jump_buffer > 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		player_jump_sfx.play()
		mario_jump_buffer = true
		can_jump = true
		is_space_hold = Input.is_action_pressed("Space")
		jump_buffer = 0
	
	#Normal_Mario_Jump
	if !is_on_floor():
		if Input.is_action_just_released("Space") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4
			can_jump = false
	
	#Buffer_Mario_Jump
	if mario_jump_buffer and !is_space_hold and velocity.y < 0 and can_jump:  # Check if "Space" was tapped during a buffered jump
			velocity.y = JUMP_VELOCITY / 2  # Cap the jump height for a tapped buffered jump
			mario_jump_buffer = false  # Reset the flag
			can_jump = false

	if is_on_floor(): #reset everything to false when on floor to make sure nothing breaks
		can_air_attack = true
		is_in_air = false
		mario_jump_buffer = false
		is_space_hold = false
		can_jump = true

		#elif Mario_jump_buffer == true:
			#velocity.y = JUMP_VELOCITY / 4
			#print("Low Mario")
			#Mario_jump_buffer = false
	#if Input.is_action_just_released("Space") and Mario_jump_buffer:
		#velocity.y = JUMP_VELOCITY / 4
		#print("MarioBuffer")
		#Mario_jump_buffer = false

	#elif jump_buffer > 0 and is_on_floor() and Mario_jump_buffer == true:
		#velocity.y = JUMP_VELOCITY / 4
		#Mario_jump_buffer = false
		#velocity.y *= 0.25
			#Mario_jump_buffer = false

	#elif Input.is_action_just_released("Space") and velocity.y < 0 or Mario_jump_buffer == true:
			#velocity.y = JUMP_VELOCITY / 4
			#Mario_jump_buffer = false
			#print(Mario_jump_buffer)
	
	#Handle Dash
	if Input.is_action_just_pressed("Dash") and dash_cooldown == false and velocity.x != 0:
		initiate_dash_flash()
		can_dash = true
		dash_cooldown = true
		dash_timer.start()
		dash_cooldown_timer.start()
		dash_flash_timer.start()
		player_dash_sfx.play()

	#Handle left right
	var direction = Input.get_axis("A", "D")
	if direction and !is_attack: #not alow player left and right when attack
		if can_dash == true:
			velocity.x = direction * DASH_SPEED * 2.5
			velocity.y = false
			initiate_dash_effect()
		else:
			velocity.x = direction * SPEED
			if !player_run_sfx.playing:
				player_run_sfx.play()
			elif !is_on_floor():
				player_run_sfx.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		player_run_sfx.stop()
		
	#Handle Attack
	if attack_cooldown == false and !is_deflect and !is_dead:
		if Input.is_action_just_pressed("Attack") and !is_attack:
			if is_on_floor():
				ground_attack()
			if !is_on_floor() and can_air_attack:
				air_attack()
	
	#Handle Deflect
	if !is_attack and !is_dead and !deflect_cooldown:
		if Input.is_action_just_pressed("Deflect"):
			deflect()
	
	#Handle Flip
	if velocity.x < 0 and !is_attack:
		$Sprite2D.flip_h = true
		$CollisionShape2D.position.x = 10
		$Player_hitbox/CollisionShape2D.position.x = 10
		$Player_AttackBox1/CollisionPolygon2D.scale.x = -1
		$Player_AttackBox2/CollisionPolygon2D.scale.x = -1
		player_direction = -1
	elif velocity.x > 0 and !is_attack:
		$Sprite2D.flip_h = false
		$CollisionShape2D.position.x = 0
		$Player_hitbox/CollisionShape2D.position.x = 0
		$Player_AttackBox1/CollisionPolygon2D.scale.x = 1
		$Player_AttackBox2/CollisionPolygon2D.scale.x = 1
		player_direction = 1
	
	update_movement_animation()
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and !is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()

func coyote_timeout():
	can_jump = false
	pass

################################# Attack + DELFECT FUNCTIONS ####################################
func ground_attack():
	player_swing_sfx.pitch_scale = randf_range(0.9,1.1)
	player_swing_sfx.play()
	if attack_string == "":
		attack1()
	elif attack_string == "Attack":
		attack2()

func air_attack():
	player_swing_sfx.pitch_scale = randf_range(0.9,1.1)
	player_swing_sfx.play()
	disable_gravity = true
	velocity.y = 0
	if attack_string == "":
		attack1()
	elif attack_string == "Attack":
		can_air_attack = false
		attack2()

	#await $AnimationPlayer.animation_finished
	#disable_gravity = false

func attack1():
		animation_player.play("Attack1")
		is_attack = true
		attack_string += "Attack"
		$Timer/Attack1Timer.start()
		if is_attack:
			if player_direction == 1:
				$CollisionShape2D.position.x = 10
				$Player_hitbox/CollisionShape2D.position.x = 10
			if player_direction == -1:
				$CollisionShape2D.position.x = -10
				$Player_hitbox/CollisionShape2D.position.x = -10

func attack2():
		animation_player.play("Attack2")
		is_attack = true
		attack_cooldown = true
		attack_string = ""
		$Timer/Attack2Timer.start()
		if is_attack:
			if player_direction == 1:
				$CollisionShape2D.position.x = 10
				$Player_hitbox/CollisionShape2D.position.x = 10
			if player_direction == -1:
				$CollisionShape2D.position.x = 0
				$Player_hitbox/CollisionShape2D.position.x = 0
	#$Timer/Attack2Timer.start()
	#disable_gravity = false
	#attack_cooldown = true

func deflect():
	if !is_dead:
		animation_player.play("Deflect")
		is_deflect = true
	#$Sprite2D.modulate = Color(0,1,0)
	#$Player_AttackBox1/CollisionPolygon2D.disabled = true
	#$Player_AttackBox2/CollisionPolygon2D.disabled = true

func dead():
	animation_player.play("Death")
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	set_collision_mask_value(8, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, false)

func buffer_jump():
		velocity.y = JUMP_VELOCITY
		#print(jump_buffer)

#Handle Health
func health_system():
	if invincible_time == false:
		player_health -= 1
		$UI/Hearts.size.x -= 16
		Global.emit_signal('screen_shake')
	if player_health == 0:
		dead()
		Global.fireball_count = 0
		$UI/Hearts.hide()
		#$UI/GameOver.game_over()
		#get_node("UI/GameOver").game_over()

func reset_health():
	player_health = 5
	$UI/Hearts.size.x = 80

func hurt_effect():
	#Handle Flash
	if player_health >= 1 and invincible_time == false:
		invincible_time = true
		var flash_tween = create_tween().set_loops(8)
		flash_tween.tween_property(self,"modulate:a",0.0,0.1)
		flash_tween.tween_property(self,"modulate:a",1.0,0.1)
		flash_tween.finished.connect(func():
			invincible_time = false
			Engine.time_scale = 1.0
			modulate = Color(1, 1, 1, 1)
		)

################################ EFFECTS CENTER #############################################
#DashEffect
func initiate_dash_effect():
	var dash_effect = dash_effect_scene.instantiate()
	get_parent().add_child(dash_effect)
	dash_effect.position = $Sprite2D.global_position
	#print(animation_player.global_position)
	#var sprite_node = dash_effect.get_node("DashEffectSprite2D")
	#sprite_node.flip_h = animation_player.flip_h
func initiate_dash_flash():
	$Sprite2D.modulate = Color(5, 5, 5, 1) # Full white
	dash_flash_timer.start()

	

################################ ANIMATIONS CENTER #############################################
func update_movement_animation():
	if !is_attack and !is_deflect and !is_dead:
		if is_on_floor() and can_dash == false:
			if velocity.x != 0:
				animation_player.play("Run")
				#$sfx_run.play()
			elif velocity.x == 0:
				animation_player.play("Idle")
		elif !is_on_floor() and can_dash == false:
			if velocity.y < 0:
				animation_player.play("Jump")
			if velocity.y > 0:
				#if finish_jump:
				animation_player.play("Fall")
				finish_jump = false
				if !coyote_timer.is_stopped():
					animation_player.play("Fall")
		elif can_dash == true:
			animation_player.play("Dash")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Jump":
		finish_jump = true
	#Attack End Animation
	if anim_name == "Attack1" or "Attack2":
		is_attack = false
		disable_gravity = false
		if player_direction == 1:
			$CollisionShape2D.position.x = 0
			$Player_hitbox/CollisionShape2D.position.x = 0
		elif player_direction == -1:
			$CollisionShape2D.position.x = 6
			$Player_hitbox/CollisionShape2D.position.x = 6
		#$Player_AttackBox1/CollisionPolygon2D.disabled = true
		#$Player_AttackBox2/CollisionPolygon2D.disabled = true
	if anim_name == "Deflect":
		is_deflect = false
		$Sprite2D.modulate = Color(1,1,1)
	if anim_name == "Death":
		$UI/Transition.play("Fade_Out")

func _on_transition_animation_finished(anim_name):
	if anim_name == "Fade_Out":
		$UI/GameOver.game_over_transition()

################################ TIMER CENTER #############################################
#Timer For Dash
func _on_dash_timer_timeout():
	can_dash = false
func _on_dash_cooldown_timer_timeout():
	dash_cooldown = false
	dash_cooldown_timer.one_shot = true
func _on_dash_flash_timer_timeout():
	$Sprite2D.modulate = Color(1, 1, 1, 1)

#Reset knockback
func _on_kncok_back_timer_timeout():
	$Sprite2D.modulate = Color(1, 1, 1, 1)

#Player gets hit
func _on_player_hitbox_area_entered(area):
	if area.is_in_group("Enemy_hitbox") or area.is_in_group("Fireball_Area2D"):
		health_system()
		hurt_effect()
		$Timer/KncokBackTimer.start()
func _on_player_deflect_box_area_entered(area): #Failed
	if area.is_in_group("Fireball_Area2D"):
		pass
		#Engine.time_scale = 0.5
		#modulate = Color(10,10,10,1)

func _on_killzone_body_entered(body):
	Global.fireball_count = 0
	get_tree().reload_current_scene()

#Attack Timer
func _on_attack_1_timer_timeout():
	attack_string = ""
func _on_attack_2_timer_timeout():
	attack_cooldown = false
func _on_air_attack_timer_timeout():
	attack_cooldown = false
