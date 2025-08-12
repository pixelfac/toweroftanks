extends Node3D

@onready var player_ref: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref  = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(player_ref.global_position)
	# shoot
	
func shoot() -> void:
	pass
	# if LOS of player
	# shoot bullet at them
	# rotate turret to same direction as shooting
