extends Level
func _physics_process(_delta):
	if nWaves == 0 and portal_spawned == false:
		spawn_portal($Pposition.position)
