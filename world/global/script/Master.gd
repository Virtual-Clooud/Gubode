extends Node
var player
func _ready():
	player = find_node("player", true, false)
func _physics_process(_delta):
	Engine.time_scale = lerp(Engine.time_scale, 1, 0.07)
