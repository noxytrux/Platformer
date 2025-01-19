extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -900.0
const SLOW_DOWN = 5

var can_jump_twice = false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(delta: float) -> void:

	if abs(velocity.x) > 1:
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("ui_accept"):
		can_jump_twice = true

	if Input.is_action_just_pressed("ui_accept") and can_jump_twice and not is_on_floor():
		can_jump_twice = false
		velocity.y = JUMP_VELOCITY * 0.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
