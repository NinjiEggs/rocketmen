extends Node3D

var firstGrowthCycleFinished : bool = false
@onready var AOEMesh : MeshInstance3D = $BombAOEMesh
@onready var Hurtbox : Area3D = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reparent(get_tree().root)
	$".".scale = Vector3(1.0, 1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AOEMesh.scale.x = lerpf(AOEMesh.scale.x, 0.1, delta * 10)
	AOEMesh.scale.y = lerpf(AOEMesh.scale.y, 0.1, delta * 10)
	AOEMesh.scale.z = lerpf(AOEMesh.scale.z, 0.1, delta * 10)


func _on_life_span_timeout() -> void:
	queue_free()
