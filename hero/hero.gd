extends CharacterBody2D

const SIDE_BIAS := 0.1

@export var movement_stats: MovementStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flip_anchor: Node2D = $FlipAnchor

var facing_direction: Vector2 = Vector2.DOWN :
	set(value):
		if value == Vector2.ZERO:
			return

		value = value.normalized()

		if abs(value.x) >= abs(value.y) - SIDE_BIAS:
			facing_direction = Vector2(sign(value.x), 0)
		else:
			facing_direction = Vector2(0, sign(value.y))

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	facing_direction = input_vector

	if facing_direction.x != 0.0:
		flip_anchor.scale.x = sign(facing_direction.x)

	if input_vector != Vector2.ZERO:
		play_animation("run")
		CharacterMover.accelerate_in_direction(self, input_vector, movement_stats, delta)
	else:
		play_animation("idle")
		CharacterMover.decelerate(self, movement_stats, delta)

	CharacterMover.move(self)

func play_animation(animation: String) -> void:
	var animation_name := animation + "_" + get_direction_string()

	animation_player.play(animation_name)

func get_direction_string() -> String:
	var direction := ""
	if facing_direction.x == 0.0:
		if facing_direction.y < 0.0:
			direction = "up"
		else:
			direction = "down"
	else:
		direction = "side"
	return direction
