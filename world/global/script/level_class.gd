extends Node2D
class_name Level

var masterN
var frame_born

onready var portal = preload("res://world/global/scene/portal.tscn")
var portal_spawned = false
var path
export var next_level : Resource

onready var current_enemies : int
var current_wave = 0
var enemies_spawned = 0
export var enemies = {"chaser": preload("res://enemies/chaser/scene/chaser.tscn")}
export var nWaves : int = 2
export var minenemies : int = 1

var tile = 0
var current_cell
var square_size = 5
var search_cell = Vector2(0,0)
var valid_spawn = false
var spawn_spots = []
var spawn_spots_check = false
var tilemap
var up : int
var down : int
var left : int
var right : int

var player

func find_spawn_spots():
	for tile_idx in range(tilemap.get_used_cells().size()):
		valid_spawn = false
		tile = tilemap.get_used_cells()[tile_idx]
		if tilemap.get_cell(tile.x, tile.y) == 2:
			var start = Vector2(tile.x - 2, tile.y - 2)
			search_cell = start
			for _y_pos in range(square_size):
				for _x_pos in range(square_size):
					if tilemap.get_cell(search_cell.x, search_cell.y) == 2:
						valid_spawn = true
						search_cell.x += 1
					else:
						valid_spawn = false
						break
				if not valid_spawn:
					break
				search_cell.y += 1
				search_cell.x = start.x
			if valid_spawn:
				spawn_spots.append(tilemap.map_to_world(tile))
func farthest_tiles():
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
func spawn_portal(Pposition):
	var ip = portal.instance()
	ip.position = Pposition
	var nl = next_level
	ip.set("next_level", nl)
	add_child(ip)
	portal_spawned = true
func _ready():
	tilemap = $Navigation2D/TileMap
	masterN = get_tree().get_root().get_node("./Master")
	path = self.get_filename()
	player = get_tree().get_root().find_node("player", true, false)
	frame_born = Engine.get_frames_drawn()
	
func _physics_process(_delta):
	if spawn_spots_check == false and is_instance_valid(tilemap):
		find_spawn_spots()
		farthest_tiles()
		spawn_spots_check = true

func enemy_spawn():
	current_enemies += 1
func enemy_died():
	current_enemies -= 1
