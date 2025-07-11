extends CharacterBody3D

var direction : float
var spawn_pos : Vector3
var spawn_rot : Vector3
var PROJECTILE_SPEED : float = 6
var init_bounces : int = 1
var current_bounces : int

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot
	current_bounces = init_bounces
	velocity = Vector3.FORWARD.rotated(Vector3.UP, global_rotation.y) * PROJECTILE_SPEED

func _physics_process(delta: float) -> void:
	var collision_data := move_and_collide(velocity * delta)
	if collision_data:
		print("collision")
		if current_bounces > 0:
			velocity = velocity.bounce(collision_data.get_normal())
			rotation.y = Vector3.FORWARD.signed_angle_to(velocity.normalized(), Vector3.UP)
			current_bounces -= 1
		else:
			queue_free()
			print("bullet explode")
	
