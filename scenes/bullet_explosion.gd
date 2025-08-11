extends Node3D

func set_start_state(pos: Vector3) -> void:
	global_position = pos

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
