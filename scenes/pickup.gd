extends StaticBody3D

@onready var run_data : RunData = preload("res://data/current_run.tres")

func _exit_tree() -> void:
	print("pickup destroyed")
	run_data.score += 1
