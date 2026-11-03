extends RigidBody3D

@export var projectileSpeed : float = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reparent(get_tree().root)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0, projectileSpeed, 0) * delta
