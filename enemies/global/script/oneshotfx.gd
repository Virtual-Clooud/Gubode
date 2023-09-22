extends Node2D
class_name OneShotFX
# Script responsible for managing one shot particle fx
var endchild
export var Nome = 10
func search():
	var longest_time = 0
	for x in get_child_count():
		if get_child(x).get("lifetime") >= longest_time:
			endchild = get_child(x)
			longest_time = get_child(x).get("lifetime")
		else:
			pass
func _ready():
	search()
	for x in get_child_count():
		get_child(x).emitting = true
func _physics_process(_delta):
	if endchild.emitting == false:
		queue_free()
