extends CharacterBody2D

var health = 2
var deflect_chance = 0
var remaining_deflects = 0
var can_spawn_fireball = true 
@onready var health_bar = $HealthBar
@onready var animation_player = $AnimationPlayer
@onready var fireball_cd_timer = $Fireball_Cd_Timer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fireball_in_deflect_area = []
var deflect_success_rate = 100.0
var deflect_drop_amount = 10.0
var is_idle = false
var is_attack = false
var is_deflect = false
var is_dead = false
var player = null
var fireball = preload("res://Scene/fireball.tscn")
var fireball_cooldown = false

func _ready():
	health_bar.value = health
	$Bubble.visible = false
	$EnemyDeflect_Box/CollisionShape2D.disabled = true
	is_idle = true

func _physics_process(delta):
	#Global.update_enemy_position(self)
	#Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Handle Flip
	var target = get_tree().get_nodes_in_group("Player")
	#var target_pos = target[0].global_position
	if target.size() > 0 and is_instance_valid(target[0]):
		var target_pos = target[0].global_position
		$Sprite2D.flip_h = target_pos < global_position
	#else:
		#queue_free()
		#if target_pos < self.position:
			#$Sprite2D.flip_h = true
		#else:
			#$Sprite2D.flip_h = false
	
	update_animation()
	move_and_slide()

#func _exit_tree():
	#Global.unregister_enemy(self)

func update_animation():
	if is_dead:
		animation_player.play("Death")
		return 
	if is_deflect and !is_attack:
		animation_player.play("Deflect")
	if is_attack and !is_deflect:
		animation_player.play("Attack1")
	if is_idle:
		animation_player.play("Idle")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack1":
		$EnemyDeflect_Box/CollisionShape2D.disabled = true
		is_attack = false
		is_idle = true
	if anim_name == "Deflect":
		is_deflect = false
		is_idle = true
		fireball_cd_timer.start()

#Range Enemy Health
func range_enemy_health_system():
	health -= 1
	health_bar.value = health
	if health <= 0 and !is_dead:
		is_dead = true
		Global.fireball_count = 0
		dead()
func range_enemy_ouch_effect():
	$Sprite2D.modulate = Color(100,100,100)
	$OuchFlash_Timer.start()

#Spawn Fireball
func spawn_fireball():
	if Global.fireball_count != Global.max_fireball_count:
		Global.fireball_count += 1
		print(Global.fireball_count)
		var initiate_fireball = fireball.instantiate()
		add_child(initiate_fireball)
		fireball_cooldown = true
		fireball_cd_timer.start()
		rng_deflect()
#RNG Deflect
func rng_deflect():
	deflect_chance = randi()%(12-(8-1))+8 #rand 8-12
	remaining_deflects = deflect_chance

func dead():
	animation_player.play("Death")
	is_attack = false
	is_deflect = false
	is_idle = false
	fireball_cd_timer.stop()
	$Detection_Area2D/CollisionShape2D.set_deferred("disabled", true)
	$EnemyDeflect_Detection/CollisionShape2D.set_deferred("disabled", true)
	#$RangeEnemy_HitBox/CollisionShape2D.set_deferred("disabled", true) ###
	$EnemyDeflect_Box/CollisionShape2D.set_deferred("disabled", true)
	
#func enemy_deflect():
	#if is_deflect:
		#return
	#if is_attack:
		#await animation_player.animation_finished
	#if randf() * 100.0 <= deflect_success_rate:
		#is_deflect = true
		#is_attack = false
		#is_idle = false
		#$EnemyDeflect_Box/CollisionShape2D.disabled = false
		#animation_player.play("Deflect")
		#deflect_success_rate = max(0.0, deflect_success_rate - deflect_drop_amount)
		#print("Deflect success! New rate: ", deflect_success_rate, "%")
	#else:
		#fireball_in_deflect_area = []
		##is_deflect = false
		##$EnemyDeflect_Box/CollisionShape2D.disabled = true
		#print("Deflect failed! (Rate: ", deflect_success_rate, "%)")

#Player Detection
func _on_detection_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		is_attack = true
		is_idle = false

func _on_detection_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		fireball_cd_timer.stop()
		is_attack = false
		is_idle = true

#Fireball Detection
func _on_enemy_deflect_detection_area_entered(area):
	if area.is_in_group("Fireball_Area2D"):
		if remaining_deflects > 0:
			remaining_deflects -= 1
			is_deflect = true
			is_attack = false
			is_idle = false
			fireball_cd_timer.stop()
			await animation_player.animation_finished
		#fireball_in_deflect_area.append(area)
		if is_attack:
			return
			await animation_player.animation_finished
		#enemy_deflect()
#func _on_enemy_deflect_detection_area_exited(area):
	#if area.is_in_group("Fireball_Area2D"):
		#fireball_in_deflect_area.erase(area)

func _on_fireball_cd_timer_timeout():
	fireball_cooldown = false
	is_attack = true
	is_idle = false
	fireball_cd_timer.stop()

func _on_ouch_flash_timer_timeout():
	$Sprite2D.modulate = Color(1,1,1)

######### ADD IN LATER ##########
	#Handle Flip
	#var target = get_tree().get_nodes_in_group("Player")
	#var target_pos = target[0].global_position
	#if target_pos < self.position:
		#$Sprite2D.flip_h = true
	#else:
		#$Sprite2D.flip_h = false
	
	#func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "Attack1":
		#is_attack = false
		#is_idle = true

###############################

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#@onready var animation_player = $AnimationPlayer
#@onready var fireball_cd_timer = $Fireball_Cd_Timer
#@export var target : Player
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var is_idle = false
#var is_attack = false
#var player = null
#var fireball = preload("res://Scene/fireball.tscn")
#var fireball_cooldown = false
#
#func _ready():
	#is_idle = true
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	##Handle_Idle
	##if is_idle:
		##handle_idle()
	##if velocity.x == 0:
		##is_idle = true
	#
	##Handle Attack
	##if is_attack and fireball_cooldown == false:
		##handle_attack()
		#pass
	#
	#update_animation()
	#move_and_slide()
#
#func handle_idle():
	#is_idle = true
	#is_attack = false
#func handle_attack():
	##spawn_fireball()
	#pass
	#
#func update_animation():
	#if is_idle:
		#animation_player.play("Idle")
	#if is_attack:
		#animation_player.play("Attack1")
#
#func spawn_fireball():
	#var initiate_fireball = fireball.instantiate()
	#add_child(initiate_fireball)
	#fireball_cooldown = true
	#fireball_cd_timer.start()
	#print("Idle:", is_idle)
	#print("Attack:", is_attack)
#
#func _on_detection_area_2d_body_entered(body):
	#if body.is_in_group("Player"):
		#player = body
		#is_attack = true
		#is_idle = false
#
#func _on_fireball_cd_timer_timeout():
	#fireball_cooldown = false
	#is_attack = true
	#is_idle = false
	#fireball_cd_timer.stop()
