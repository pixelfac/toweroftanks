extends CharacterBody3D

# the direction the tank is moving, defined in rotation around y axis, in radians
var moving_direction : float = 0
var is_reversing : bool = false
var current_speed : float = 0.0

@export_group("Action Toggles")
@export var can_move : bool = true
@export var can_sprint : bool = false
@export var can_shoot : bool = true

@onready var turretNode := $Turret
@onready var player_tank_data = preload("res://data/player_tank_data.tres")

@export_group("Input Actions")
@export var input_left : String = "move_left"
@export var input_right : String = "move_right"
@export var input_forward : String = "move_up"
@export var input_back : String = "move_down"
@export var input_sprint : String = "sprint"

func _ready() -> void:
	check_input_mappings()

func _physics_process(_delta: float) -> void:
	compute_move()
	compute_shoot()
	
	move_and_slide()

# sets player velocity based on state
func compute_move() -> void:
	if not can_move:
		velocity = velocity.lerp(Vector3.ZERO, player_tank_data.deceleration)
		return
	
	if can_sprint and Input.is_action_pressed(input_sprint):
		current_speed = player_tank_data.boost_speed
	else:
		current_speed = player_tank_data.base_speed
	
	var input_dir_vector := Input.get_vector(input_left, input_right, input_forward, input_back)
	var new_move_dir_vector := Vector3(input_dir_vector.x, 0, input_dir_vector.y).normalized()
	new_move_dir_vector = new_move_dir_vector.rotated(Vector3.UP,-PI/4) #rotate movement 45 degrees to account for isometric camera view
	
	if not new_move_dir_vector: #if no data received from Inputs
		velocity = velocity.lerp(Vector3.ZERO, player_tank_data.deceleration)
		return
	
	compute_rotation(new_move_dir_vector)
	
	if is_reversing:
		moving_direction = (PI if rotation.y < 0 else -PI) + rotation.y
	else:
		moving_direction = rotation.y
		
	velocity = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * (-1 if is_reversing else 1) * current_speed

# sets player rotation based on state
func compute_rotation(move_dir: Vector3) -> void:
	# get vector of curr moving direction
	var moving_dir_vector := Vector3.FORWARD.rotated(Vector3.UP, moving_direction)
	# get angle between new and previous directions
	var relative_dir_change := moving_dir_vector.signed_angle_to(move_dir, Vector3.UP)
	if (relative_dir_change > (PI/2 + 0.1) or relative_dir_change < (-PI/2 - 0.1)):
		# if rotation to face new_moving_dir > 90 degrees, switch to moving in reverse
		relative_dir_change = (PI if relative_dir_change > 0 else -PI) - relative_dir_change
		is_reversing = !is_reversing
	
	rotate_y(relative_dir_change * player_tank_data.turn_speed)

func compute_shoot() -> void:
	if can_shoot and Input.is_action_pressed("PrimaryAttack"):
		turretNode.shoot()
	
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
