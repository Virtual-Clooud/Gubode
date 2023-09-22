extends Node2D

export var gib_sprite : Texture
export var Ngibs : int
export var gibsDirection : Vector2
onready var gib = preload("res://enemies/global/scene/gib.tscn")
func directed_death(direction):
	for x in range(Ngibs + 1):
		var igib = gib.instance()
		igib = Vector2(100,rand_range(60,-60)).rotated(direction)
		get_tree().get_root().add_child(igib)
	queue_free()
