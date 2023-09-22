extends Node2D

func _ready():
	$CPUParticles2D.emitting = true
	$circle.emitting = true
func _physics_process(delta):
	if $CPUParticles2D.emitting == false:
		queue_free()
