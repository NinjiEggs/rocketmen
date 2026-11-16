extends Node3D

@export var mouseSensitivity : float = 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minVerticalAngle : float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxVerticalAngle : float = PI/4

@onready var springArm : SpringArm3D = $SpringArm3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	
	if not owner.is_multiplayer_authority():
		return
	if owner.cameraMovement == true:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * mouseSensitivity
			rotation.y = wrapf(rotation.y, 0.0, TAU)
			
			rotation.x -= event.relative.y * mouseSensitivity
			rotation.x = clamp(rotation.x, minVerticalAngle, maxVerticalAngle)
		
		if event.is_action_pressed("wheelUp"):
			springArm.spring_length -= 1
		if event.is_action_pressed("wheelDown"):
			springArm.spring_length += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
