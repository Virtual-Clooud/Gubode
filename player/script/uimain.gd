extends Control
# U.I do jogador

onready var player = get_node("../../")

var current_life
var max_life
var discrepancy
var tween

export var heart_sprite : Texture
export var heart_empty_sprite : Texture

func create_list():
	for _x in range(0, max_life):
		var new_heart = TextureRect.new()
		$HBoxContainer.add_child(new_heart)
		new_heart.set_texture(heart_empty_sprite)
func update_hearts():
	discrepancy = max_life - current_life
	for x in range(0, current_life):
		$HBoxContainer.get_children()[x].set_texture(heart_sprite)
	for _y in range(0, discrepancy):
		if discrepancy == max_life:
			break
		else:
			$HBoxContainer.get_children()[max_life - discrepancy].set_texture(heart_empty_sprite)
func _ready():
	max_life = player.maxlife
	create_list()

func _physics_process(_delta):
#	rect_position = get_node("..").position
#	rect_position.y -= 400
	$HBoxContainer.rect_scale = Vector2(0.2,0.2)
	current_life = player.life
	update_hearts()
	
