extends Weapon
# Script responável por ser a pistola


export var alt_shots = 6
export var spread = 60

onready var root = get_node("../..")
onready var muzzle = find_node("muzzle")

onready var default_shot = preload("res://player/scene/default_shot.tscn")
onready var alt_shot = preload("res://player/weapons/revolver/scene/alt_shot.tscn")
onready var shotfx = preload("res://player/weapons/revolver/scene/pistol_shot_fx.tscn")
onready var altshotfx = preload("res://player/weapons/revolver/scene/alt_shot_fx.tscn")
onready var smoke_fx = preload("res://player/weapons/revolver/scene/smoke_fx.tscn")
onready var bullet_eject_fx = preload("res://player/weapons/revolver/scene/bullet_eject_fx.tscn")
func smoke():
	yield(get_tree().create_timer(0.2), "timeout")
	var ismoke = smoke_fx.instance()
	ismoke.rotation = $Sprite.rotation
	ismoke.position = Vector2(30,0).rotated($Sprite.rotation)
	add_child(ismoke)
func _physics_process(_delta):
	var rot = get_angle_to(get_global_mouse_position())
	if $Sprite.rotation_degrees <= -90 or $Sprite.rotation_degrees >= 90:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
	match state:
		"idle":
			var tween = create_tween()
			tween.tween_property($Sprite, "position", 
			Vector2(20, 0).rotated(rot), 0.01)
			tween.tween_property(muzzle, "position", 
			Vector2(75, 0).rotated(rot), 0.01)
			tween.tween_property($Sprite, "rotation_degrees", 
			rad2deg(get_angle_to(
				get_global_mouse_position())), 0.01)

		"set":
			var tween = create_tween()
			tween.tween_property($Sprite, "position", 
			Vector2(50, 0).rotated(rot), 0.01)
			tween.tween_property(muzzle, "position", 
			Vector2(75, 0).rotated(rot), 0.01)
			tween.tween_property($Sprite, "rotation_degrees", 
			rad2deg(get_angle_to(
				get_global_mouse_position())), 0.01)
		"active":
			if can_Pshoot:
				var bullet = default_shot.instance()
				if power_ups["Pri"] == 0:
					bullet.status.append("slow")
				simple_shot(bullet, 
				get_angle_to(get_global_mouse_position()), 
				to_global(Vector2(65, 0).rotated(rot)),
				bullet_speed, dmg)
				can_Pshoot = false
				Pshot_frame = Engine.get_frames_drawn()
				var ishot = shotfx.instance()
				ishot.rotation = $Sprite.rotation
				ishot.position = Vector2(80,-10).rotated($Sprite.rotation)
				add_child(ishot)

				

				yield(get_tree().create_timer(0.05), "timeout")
				var ibullet = bullet_eject_fx.instance()
				ibullet.rotation = $Sprite.rotation
				add_child(ibullet)

				smoke()
			state = "idle"
			
		"alt_set":
			var tween = create_tween()
			tween.tween_property($Sprite, "position", 
			Vector2(50, 0).rotated(rot), 0.05)
			tween.tween_property(muzzle, "position", 
			Vector2(75, 0).rotated(rot), 0.05)
			tween.tween_property($Sprite, "rotation_degrees", 
			rad2deg(get_angle_to(
				get_global_mouse_position())), 0.01)
		"alt_active":
			if can_Sshoot:
				simple_mult_shot(alt_shot, 
				get_angle_to(get_global_mouse_position()), 
				to_global(Vector2(65, 0).rotated(rot)),
				alt_bullet_speed, alt_dmg, alt_shots, spread)
				Sshot_frame = Engine.get_frames_drawn()
				can_Sshoot = false
				for _x in range(0, alt_shots):
					var ishot = altshotfx.instance()
					ishot.rotation = $Sprite.rotation
					ishot.position = Vector2(80,-10).rotated($Sprite.rotation)
					yield(get_tree().create_timer(0.05), "timeout")
					add_child(ishot)
			state = "idle"

