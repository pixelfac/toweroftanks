extends Node3D

var offset: Vector3
var player_loc: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = position
	player_loc = get_parent_node_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player_loc.global_position + offset
