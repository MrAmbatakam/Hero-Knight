extends Node

signal screen_shake

var fireball_count = 0
var max_fireball_count = 3
#UI
var fullscreen_count = 0
var volume_slider

# Dictionary to store enemy positions by their instance ID
var enemy_positions = {}

# Called when an enemy registers itself
func register_enemy(enemy: Node2D):
	var id = enemy.get_instance_id()
	enemy_positions[id] = enemy.global_position
	
# Connect to the enemy's tree_exited signal to clean up
	if not enemy.tree_exited.is_connected(_on_enemy_exited.bind(id)):
		enemy.tree_exited.connect(_on_enemy_exited.bind(id))

# Called when an enemy unregisters or is freed
func unregister_enemy(enemy: Node2D):
	var id = enemy.get_instance_id()
	if enemy_positions.has(id):
		enemy_positions.erase(id)

# Clean up when enemy exits tree
func _on_enemy_exited(id: int):
	if enemy_positions.has(id):
		enemy_positions.erase(id)

# Update position for a specific enemy
func update_enemy_position(enemy: Node2D):
	var id = enemy.get_instance_id()
	if enemy_positions.has(id):
		enemy_positions[id] = enemy.global_position

# Get position for a specific enemy
func get_enemy_position(enemy: Node2D) -> Vector2:
	var id = enemy.get_instance_id()
	return enemy_positions.get(id, Vector2.ZERO)
