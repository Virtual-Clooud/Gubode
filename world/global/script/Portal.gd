extends Sprite
# Script responsável pelo funcionamento de portais
export var next_level : Resource


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var ilevel = next_level.instance()
		get_tree().get_root().add_child(ilevel)
		self.get_parent().queue_free()
