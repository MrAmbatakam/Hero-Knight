extends Camera2D

@onready var shake_timer = $Shake_Timer
@onready var shake_intensity = 0
var default_offset = offset

@export var ouch_shake_intensity = 1

func _ready():
	Global.screen_shake.connect(screen_shake)
	set_process(false)
	randomize()

func _process(delta):
	var shake_vector = Vector2(randf_range(-1,1) * shake_intensity, randf_range(-1,1) * shake_intensity)
	var shake_tween = create_tween()
	shake_tween.tween_property(self,"offset",shake_vector,0.1)

func shake(intensity):
	shake_intensity = intensity
	set_process(true)
	shake_timer.start()

func screen_shake():
	shake(ouch_shake_intensity)

func _on_shake_timer_timeout():
	set_process(false)
	var return_tween = create_tween()
	return_tween.tween_property(self,"offset",default_offset,0.1)
