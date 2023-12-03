extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
var was_on_floor = true
var landing_animation = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("jump")
	else:
		# Check for landing
		if !was_on_floor:
			animated_sprite_2d.play("land")
			landing_animation = true
			was_on_floor = true
		# Handle Jump.
		elif Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			was_on_floor = false

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip sprite and play walking animation.
		if is_on_floor():
			animated_sprite_2d.flip_h = direction < 0
			animated_sprite_2d.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Play idle animation when not moving.
		if is_on_floor() and animated_sprite_2d.animation != "land":
			animated_sprite_2d.play("idle")

	move_and_slide()

func _on_animated_sprite_2d_animation_looped():
	if landing_animation == true:
		animated_sprite_2d.play("idle")
