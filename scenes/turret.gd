extends MeshInstance3D

var camera : Camera3D
@onready var cannon := $Cannon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var plane = Plane(Vector3.UP, cannon.global_position.y)
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_dir := camera.project_ray_normal(mouse_position)
	var intersect = plane.intersects_ray(ray_origin, ray_dir)
	if intersect:
		look_at(intersect)
		rotation.x = 0
		rotation.z = 0

func shoot():
	print("shooting bullet")
