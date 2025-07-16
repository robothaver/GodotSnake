extends Node


var score: int = 0
@onready var apple = $"../Apple"

func _on_apple_area_shape_entered(area_rid: RID, area, area_shape_index: int, local_shape_index: int) -> void:
	var rng = RandomNumberGenerator.new()
	var row = rng.randi_range(0, 13)
	var col = rng.randi_range(0, 23)
	apple.global_position = Vector2(-529 + (col * 46), -253 + (row * 46))
	var scoreLabel: Label = get_node("ScoreLabel")
	score += 1
	scoreLabel.text = "Score: " + str(score)


func _on_world_border_area_shape_entered(area_rid: RID, area, area_shape_index: int, local_shape_index: int) -> void:
	get_tree().reload_current_scene()
