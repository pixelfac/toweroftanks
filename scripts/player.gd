extends CharacterBody3D

@export var can_move : bool = true
@export var has_gravity : bool = true
@export var can_sprint : bool = false

@export_group("Speeds")
@export var base_speed : float = 7.0
@export var sprint_speed : float = 10.0
# value in range (0,1], 1 being instant decel
@export var DECELERATION : float = 0.25
@export var TURN_SPEED : float = 0.05

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
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := Vector3(input_dir.x, 0, input_dir.y).normalized()
		print("rotation: ", rotation)
		print("move_dir: ", move_dir)
		if move_dir:
			#velocity.x = move_dir.x * current_speed
			#velocity.z = move_dir.z * current_speed
			var move_dir_angle = Vector3.FORWARD.signed_angle_to(move_dir, Vector3.UP)
			print(move_dir_angle)
			rotation.y = lerp(rotation.y, move_dir_angle, TURN_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)
			
	else:
		velocity = Vector3.ZERO
	
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
