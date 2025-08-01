extends MeshInstance3D

var camera : Camera3D
@onready var cannon := $Cannon
@onready var bullet_origin := $BulletOrigin
@onready var shoot_cooldown_timer := $ShootCooldown
@onready var scene_root := get_tree().root.get_child(0)
@onready var bullet := preload("res://scenes/bullet.tscn")
@onready var player_tank_data := preload("res://data/player_tank_data.tres")
@onready var plane = Plane(Vector3.UP, cannon.global_position.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_dir := camera.project_ray_normal(mouse_position)
	var intersect = plane.intersects_ray(ray_origin, ray_dir)
	if intersect:
		look_at(intersect)
		rotation.x = 0
		rotation.z = 0

func shoot():
	if !shoot_cooldown_timer.is_stopped():
		return
		
	print("shooting bullet")
	#create bullet object
	var instance := bullet.instantiate()
	instance.set_start_state(bullet_origin.global_position,
							bullet_origin.global_rotation,
							player_tank_data.bullet_data)
	scene_root.add_child.call_deferred(instance)
	
	shoot_cooldown_timer.start(1 / player_tank_data.fire_rate)
	
	
