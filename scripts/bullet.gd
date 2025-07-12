extends CharacterBody3D

var direction : float
var spawn_pos : Vector3
var spawn_rot : Vector3
var PROJECTILE_SPEED : float
var init_bounces : int
var current_bounces : int

func set_start_state(spos : Vector3, srot : Vector3, projspeed : float, bounces : int) -> void:
	spawn_pos = spos
	spawn_rot = srot
	PROJECTILE_SPEED = projspeed
	init_bounces = bounces

func _ready() -> void:
	print("ready")
	global_position = spawn_pos
	global_rotation = spawn_rot
	current_bounces = init_bounces
	velocity = Vector3.FORWARD.rotated(Vector3.UP, global_rotation.y) * PROJECTILE_SPEED

func _physics_process(delta: float) -> void:
	var collision_data := move_and_collide(velocity * delta)
	if not collision_data:
		return 
		
	var collider : PhysicsBody3D = collision_data.get_collider()
	if not is_instance_valid(collider):
		return
		
	collide(collider.collision_layer, collision_data)

func collide(other_collision_layer : int, collision_data : KinematicCollision3D) -> void:
	match other_collision_layer:
		8: # (layer 4  - 1)^2 = 8
			if current_bounces > 0:
				bounce(collision_data.get_normal())
			else:
				destroy()
		16: # (layer 5  - 1)^2 = 15
			print("direct hit!")
			collision_data.get_collider().queue_free()
			destroy()
		_:
			print("uncaught collision")
			print("collision layer:", other_collision_layer)
			
func destroy() -> void:
	print("bullet destroy")
	queue_free()
	
func bounce(collision_normal : Vector3) -> void:
	velocity = velocity.bounce(collision_normal)
	rotation.y = Vector3.FORWARD.signed_angle_to(velocity.normalized(), Vector3.UP)
	current_bounces -= 1
	
