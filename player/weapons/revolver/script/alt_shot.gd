extends Bullet
# Script responsável pela programação principal do tiro alternativo

func _physics_process(_delta) -> void:
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)
	#Para ver se tem alvo
	if has_target:
		yield(get_tree().create_timer(0.01), "timeout")
		chase(target)
	else:
		velocity = Vector2(speed,0).rotated(rotation)
	




