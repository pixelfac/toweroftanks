extends Node3D

var spawn_position: Vector3

func set_start_state(pos: Vector3) -> void:
	spawn_position = pos

func _ready() -> void:
	global_position = spawn_position

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
