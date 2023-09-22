extends Bullet
# Script do tiro padrão

func _physics_process(_delta):
	move_and_slide(velocity, Vector2.UP)
	bounce()
func _on_hit_area_area_entered(area):
	if area.is_in_group("enemy"):
		if bounced == true:
			for x in status.size():
				if area.get_parent().get("status").has(status[x]):
					pass
				else:
					area.get_parent().get("status").append(status[x])
				queue_free()
		else:
			queue_free()

