extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 7
@export var maxAirJumps : int = 1
var currentAirJumps : int = maxAirJumps
var cameraMovement : bool = true
var moveDisabled : bool = false
@onready var Camera := $CameraPivot/Camera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and currentAirJumps > 0:
		velocity.y = JUMP_VELOCITY
		if is_on_floor() == false:
			currentAirJumps -= 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var Direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Direction:
		Direction = Direction.rotated(Vector3.UP, Camera.global_rotation.y)
		velocity.x = Direction.x * SPEED
		velocity.z = Direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if is_on_floor():
		currentAirJumps = maxAirJumps

	move_and_slide()
