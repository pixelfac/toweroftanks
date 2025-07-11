extends CharacterBody3D

var direction : float
var spawn_pos : Vector3
var spawn_rot : Vector3
var PROJECTILE_SPEED : float = 3

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot

func _physics_process(_delta: float) -> void:
	velocity = Vector3.FORWARD.rotated(Vector3.UP, global_rotation.y) * PROJECTILE_SPEED
	move_and_slide()
