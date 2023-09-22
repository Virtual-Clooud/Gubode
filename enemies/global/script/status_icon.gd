extends Sprite
# Script responsável pelo status?
export var icons = {"target":
	preload("res://enemies/global/img/target.png")}
var frame_born
var time

func _ready():
	frame_born = Engine.get_frames_drawn()
func _physics_process(_delta):
	if Engine.get_frames_drawn() >= ((Engine.get_frames_per_second() * time)):
		queue_free()

