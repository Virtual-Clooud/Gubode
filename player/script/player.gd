extends Player
# Script responsável pelo jogador


onready var level = get_node("..")


export var min_ult = 0

func set_limit():
		var tile
		var up = 0
		var down = 0
		var right = 0
		var left = 0
		if camera_limit == false:
			for tile_idx in range(tilemap.get_used_cells().size()):
				tile = tilemap.get_used_cells()[tile_idx]
				if tilemap.map_to_world(tile).y <= up:
					up = tilemap.map_to_world(tile).y
				if tilemap.map_to_world(tile).y >= down:
					down = tilemap.map_to_world(tile).y
				if tilemap.map_to_world(tile).x >= right:
					right = tilemap.map_to_world(tile).x
				if tilemap.map_to_world(tile).x <= left:
					left = tilemap.map_to_world(tile).x
				$Camera2D.limit_bottom = down + 100
				$Camera2D.limit_top = up - 100
				$Camera2D.limit_left = left - 100
				$Camera2D.limit_right = right + 100
				camera_limit = true
func camera_mouse_follow():
	if position.distance_to(get_global_mouse_position()) <= 700:
		$Camera2D.offset = lerp($Camera2D.offset, 
			$Camera2D.offset + $Camera2D.offset.direction_to(
				get_local_mouse_position()), 
			0.8)
	else:
		$Camera2D.offset = lerp($Camera2D.offset, 
			$Camera2D.offset + $Camera2D.offset.direction_to(
				Vector2(0,0)), 
			0.1)
	if Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("right"):
		$Camera2D.offset = lerp($Camera2D.offset, Vector2(0,0),0.1)
func _ready():
	masterN = get_tree().get_root().get_node("./Master")
func _physics_process(_delta):
	tilemap = get_node("../Navigation2D/TileMap")
	camera_mouse_follow()
	set_limit()

	if tilemap != null:
		var position = tilemap.to_local(global_position)
		var map_position = tilemap.world_to_map(position)
		var tile = tilemap.get_cell(map_position.x,map_position.y)
		
		# Detect tiles and change behaviour based on what is player is stepping on
		match tile:
			# Floor Trap
			0:
				floor_trap()
	else:
		tilemap = get_node("../Navigation2D/TileMap")


func _on_hit_detect_area_entered(area):
	if area.is_in_group("enemy_attack"):
		if can_lose_life[0]:
			life = life - 1
			can_lose_life = [false, Engine.get_frames_drawn()]
