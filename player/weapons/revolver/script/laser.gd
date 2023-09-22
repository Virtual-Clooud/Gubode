extends Area2D

# Fazer isso funciona direito
func _on_Area2D_area_entered(area):
	$Line2D.points[1] = $Line2D.points[1].direction_to(area.position)
	$Line2D.points[2] = Vector2(100,0).bounce(area.position)
	


func _on_Area2D_body_entered(body):
	$Line2D.points[1] = $Line2D.points[1].direction_to(body.position)
	$Line2D.points[2] = Vector2(100,0).bounce(body.position)
