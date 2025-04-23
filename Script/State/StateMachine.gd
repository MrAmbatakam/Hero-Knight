extends Node
class_name StateMachine
#
#@export var character : CharacterBody2D
#@export var animated_sprite : AnimatedSprite2D
#@export var initial_state : State
#
#var current_state : State
#var states : Dictionary = {}
#
func _ready():
	pass
	#for child in get_children():
		#if child is State:
			#states[child.name] = child
			#child.Transition.connect(state_transition)
		#
		#if initial_state:
			#initial_state.enter()
			#current_state = initial_state
#
#func _process(delta):
	#if current_state:
		#current_state.update(delta)
	#
#func _physics_process(delta):
	#if current_state:
		#current_state.physics_update(delta)
	#
#func state_transition(state, new_state_name):
	#if state != current_state:
		#return
	#var new_state = states.get(new_state_name)
	#if !new_state:
		#return
	#
	## Clean up the previous state
	#if current_state:
		#current_state.exit()
	#
	## Intialize the new state
	#new_state.enter()
	#current_state = new_state
