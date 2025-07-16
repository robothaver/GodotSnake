extends Node2D

@export var head: Part
@export var body: Part
@export var tail: Part
@export var moveDistance: float = 0.01
@export var turnDuration: float = 1
@export var rotationSpeed: float = 1

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var direction: Vector2 = RIGHT
var currentTurnDuration: float = 0
var parts: Array[Part] = []

func _enter_tree() -> void:
	parts.append_array([tail, body, head])

func _process(delta: float) -> void:
	currentTurnDuration -= delta
	handleInput()
	tryUpdateTurn()
	updatePartTransforms(delta)
	
func handleInput():
	if Input.is_action_just_pressed("MOVE_DOWN"):
		if direction != UP:
			direction = DOWN
	elif Input.is_action_just_pressed("MOVE_UP"):
		if direction != DOWN:
			direction = UP
	elif Input.is_action_just_pressed("MOVE_LEFT"):
		if direction != RIGHT:
			direction = LEFT
	elif Input.is_action_just_pressed("MOVE_RIGHT"):
		if direction != LEFT:
			direction = RIGHT
			
func tryUpdateTurn():
	if currentTurnDuration < 0:
		currentTurnDuration = turnDuration
		setTargetPositionsForParts()
		head.setTargetPosition(head.targetPosition + Vector2(direction.x * 46, direction.y * 46))


func updatePartTransforms(delta: float):
	for i in range(parts.size()):
		var currentPart: Part = parts[i]
		var targetPosition: Vector2 = currentPart.targetPosition

		if targetPosition.x > currentPart.startPosition.x:
			if currentPart.targetRotation == 270:
				currentPart.rotation_degrees = 0
			currentPart.targetRotation = 0
		if targetPosition.x < currentPart.startPosition.x:
			currentPart.targetRotation = 180
		if targetPosition.y > currentPart.startPosition.y:
			currentPart.targetRotation = 90
		elif targetPosition.y < currentPart.startPosition.y:
			if currentPart.targetRotation == 0:
				currentPart.rotation_degrees = 360
			currentPart.targetRotation = 270

		currentPart.rotation_degrees = lerpf(currentPart.rotation_degrees, currentPart.targetRotation, rotationSpeed * delta)
		currentPart.global_position = currentPart.global_position.lerp(targetPosition, moveDistance * delta)


func setTargetPositionsForParts():
	for i in range(parts.size()):
		if i != parts.size() - 1:
			var currentPart: Part = parts[i]
			var nextPart: Part = parts[i + 1]
			currentPart.setTargetPosition(nextPart.targetPosition)

func _on_apple_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	head.play("eat")
	var newPart: Part = Part.new()
	newPart.setAsBody(tail.startPosition)
	parts.insert(1, newPart)
	setTargetPositionsForParts()
	add_child(newPart)

func _on_rigid_body_2d_area_shape_entered(area_rid: RID, area, area_shape_index: int, local_shape_index: int) -> void:
	print(area)
	get_tree().reload_current_scene()
