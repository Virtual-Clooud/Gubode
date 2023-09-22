extends Control

var player
onready var life_bar = $TextureProgress
var maxlife
var life
func _ready():
	player = get_node("..").get_parent().get_parent()
	
	maxlife = player.get("maxlife")
	life = player.get("life")
	
	life_bar.set_max(maxlife)
func _physics_process(delta):
	life = player.get("life")
	life_bar.set_value(life)
