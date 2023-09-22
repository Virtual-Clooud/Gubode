extends TextureButton

export var scene : Resource

func _on_play_pressed():
	var iscene = scene.instance()
	get_tree().get_root().add_child(iscene)
	self.get_parent().get_parent().queue_free()

func _on_play_mouse_entered():
	pass

func _on_play_mouse_exited():
	pass
