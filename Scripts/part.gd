class_name Part extends Node2D

var targetPosition = global_position
var startPosition
var targetRotation = 0

func setTargetPosition(newPosition):
	startPosition = targetPosition
	targetPosition = newPosition

func setAsBody(initialPosition: Vector2):
	global_position = initialPosition
	targetPosition = initialPosition
	var sprite = Sprite2D.new()
	var texture = load("res://Assets/SnakeBody.png")
	sprite.texture = texture
	add_child(sprite)
	
	var area2d: Area2D = Area2D.new()
	var new_area = Area2D.new()
	new_area.collision_layer = 2
	var new_collision = CollisionShape2D.new()
	var new_shape = RectangleShape2D.new()
	new_shape.extents = Vector2(5,5)
	new_collision.shape = new_shape
	new_area.add_child(new_collision)

	add_child(new_area)
