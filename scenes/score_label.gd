extends RichTextLabel

@onready var run_data : RunData = preload("res://data/current_run.tres")

func _process(_delta: float) -> void:
	text = str("Score: ", run_data.score)
