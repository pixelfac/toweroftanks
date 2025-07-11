extends CharacterBody3D

# the direction the tank is moving, defined in rotation around y axis, in radians
var moving_direction : float = 0
var is_reversing : bool = false

@export var can_move : bool = true
@export var has_gravity : bool = true
@export var can_sprint : bool = false
@export var can_shoot : bool = true

@onready var turretNode := $Turret
@export var camera : Camera3D

@export_group("Speeds")
@export var base_speed : float = 7.0
@export var sprint_speed : float = 10.0
# value in range (0,1], 1 being instant decel
@export var DECELERATION : float = 0.25
@export var TURN_SPEED : float = 0.2

@export_group("Input Actions")
@export var input_left : String = "move_left"
@export var input_right : String = "move_right"
@export var input_forward : String = "move_up"
@export var input_back : String = "move_down"
@export var input_sprint : String = "sprint"

var current_speed : float = 0.0



func _ready() -> void:
	check_input_mappings()

func _physics_process(delta: float) -> void:
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
		current_speed = sprint_speed
	else:
		current_speed = base_speed
		
	if can_move:
		var input_dir_vector := Input.get_vector(input_left, input_right, input_forward, input_back)
		var new_move_dir_vector := Vector3(input_dir_vector.x, 0, input_dir_vector.y).normalized()
		#print("rotation: ", rotation)
		#print("move_dir_vector: ", move_dir_vector)
		if new_move_dir_vector:
			# get vector of curr moving direction
			var moving_dir_vector := Vector3.FORWARD.rotated(Vector3.UP, moving_direction)
			# get angle between new and previous directions
			var relative_dir_change := moving_dir_vector.signed_angle_to(new_move_dir_vector, Vector3.UP)
			print("relative_dir_change:", relative_dir_change)
			if (relative_dir_change > (PI/2 + 0.1) or relative_dir_change < (-PI/2 - 0.1)):
				# if rotation to face new_moving_dir > 90 degrees, switch to moving in reverse
				var new_reversing_state := !is_reversing
				if new_reversing_state != is_reversing:
					relative_dir_change = (PI if relative_dir_change > 0 else -PI) - relative_dir_change
					is_reversing = !is_reversing
			
			print("relative_dir_change:", relative_dir_change)
			print("is_reversing:", is_reversing)
			rotate_y(relative_dir_change)
			if is_reversing:
				moving_direction = (PI if rotation.y > 0 else -PI) - rotation.y
			else:
				moving_direction = rotation.y
			print("moving_direction:", moving_direction)
			velocity = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * (-1 if is_reversing else 1) * current_speed
			print("velocity:", velocity)
		else:
			velocity = Vector3.ZERO
	else:
		velocity = Vector3.ZERO
		
	if can_shoot:
		if Input.is_action_just_pressed("PrimaryAttack"):
			turretNode.shoot()
	
	# Use velocity to actually move
	move_and_slide()

## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
