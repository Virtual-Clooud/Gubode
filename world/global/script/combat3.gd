extends Level

# 1 wave de 5 smol 1 big
# 2 wave 2 big
# 3 wave 7 smol 3 big
func _physics_process(_delta):
	if current_enemies == 0:
		match current_wave:
			0:
				for _x in range(0,2):
					var ienemy = enemies["chaser"].instance()
					ienemy.maxlife = 100
					ienemy.rush_multiplier = 6
					ienemy.position = Vector2(spawn_spots[rand_range(0, spawn_spots.size())])
					add_child(ienemy)
				current_wave += 1
			1:
				for _x in range(0,7):
					var ienemy = enemies["chaser"].instance()
					ienemy.maxlife = 20
					ienemy.position = Vector2(spawn_spots[rand_range(0, spawn_spots.size())])
					add_child(ienemy)
				for _x in range(0,3):
					var ienemy = enemies["chaser"].instance()
					ienemy.maxlife = 100
					ienemy.rush_multiplier = 6
					ienemy.position = Vector2(spawn_spots[rand_range(0, spawn_spots.size())])
					add_child(ienemy)
				current_wave += 1
	if current_wave > 1 and current_enemies == 0 and portal_spawned == false:
		spawn_portal($Pposition.position)
		
