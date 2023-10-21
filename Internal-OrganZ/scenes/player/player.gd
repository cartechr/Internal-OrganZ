extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

@export var sprint_speed := 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("sprint"):
		velocity.x = direction * sprint_speed
	else:
		velocity.x = direction * SPEED

	move_and_slide()
	
	if not is_on_floor():
		anim.play("jump")
	elif is_zero_approx(direction):
		anim.play("idle")
	else:
		if Input.is_action_pressed("sprint"):
			anim.play("sprint")
		else:
			anim.play("walk")
		sprite.flip_h = direction < 0
