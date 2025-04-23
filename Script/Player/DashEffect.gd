extends AnimatedSprite2D

@onready var ghost_effect_sprite_2d = $"."
@onready var dash_effect_sprite_2d = $"."

var can_flip = true
# Called when the node enters the scene tree for the first time.
func _ready():
	dash_effect_sprite_2d.play("Dash_Effect")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Tween
	var fade_tween = create_tween()
	fade_tween.tween_property(self,"modulate:a",0.0,0.1)
	#var scale_tween = create_tween()
	#scale_tween.tween_property(self, "scale", Vector2(), 1)
	#Sprite Flip
	var effect_direction = Input.get_axis("A","D")
	if effect_direction < 0 and can_flip == true:
		ghost_effect_sprite_2d.flip_h = true
	elif effect_direction > 0:
		can_flip = false
	
	
	

	#var effect_direction = Input.get_axis("A","D")
	#if effect_direction < 0:
		#ghost_effect_sprite_2d.flip_h = true
		#print(can_flip)
		
		
	#tween.tween_property(self, "position", ghost_effect_sprite_2d.position.x + 10, 2)
	#tween.tween_property(self, "position.x", position.x + 10, 0.5)
	#ghost_effect_sprite_2d.modulate = Color(1,1,1,0.5)
	#$DashEffectTimer.start()

func _on_dash_effect_gone_timer_timeout():
	pass
