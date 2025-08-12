extends Node3D

var player_ref: Node3D
@onready var turret_node := $Turret
@export var tank_data: TankData = preload("res://data/turret_tank_data.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref  = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shoot()

	
func shoot() -> void:
	pass
	# if LOS of player
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(global_position, player_ref.global_position)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	
	if result.is_empty():
		print("hit nothing")
		return
		
	var collider : PhysicsBody3D = result["collider"]
	if not is_instance_valid(collider):
		print("hit not PhysicsBody3D")
		return
	
	if collider.collision_layer == 2:
		print("hit player")
	else:
		print("hit not player")
		
	# shoot bullet at them
	# rotate turret to same direction as shooting
