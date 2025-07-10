extends Area3D

func _on_body_entered(_body: Node3D) -> void:
	print("collision with pickup")
	queue_free()
