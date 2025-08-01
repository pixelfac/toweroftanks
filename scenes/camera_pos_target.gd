extends Node3D

var offset: Vector3
var player_node: Node3D

func _ready() -> void:
	offset = position
	player_node = get_parent_node_3d()

func _process(_delta: float) -> void:
	global_position = player_node.global_position + offset
