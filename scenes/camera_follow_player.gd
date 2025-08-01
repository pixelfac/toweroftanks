extends Camera3D

@export var player_node: Node3D
var camera_target: Node3D
var LERP_SPEED: float = 0.1

func _ready() -> void:
	camera_target = player_node.get_node("CameraPosTarget")

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(camera_target.global_position, LERP_SPEED)
	global_rotation = global_rotation.lerp(camera_target.rotation, LERP_SPEED)
