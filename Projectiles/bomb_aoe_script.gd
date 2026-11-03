extends MeshInstance3D

var firstGrowthCycleFinished : bool = false
@onready var AOEMesh : MeshInstance3D = $BombAOEMesh
@onready var Hurtbox : Area3D = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if firstGrowthCycleFinished == false:
		AOEMesh.scale.x = lerpf(AOEMesh.scale.x, 4.56, delta * 6)
		AOEMesh.scale.y = lerpf(AOEMesh.scale.y, 4.56, delta * 6)
		AOEMesh.scale.z = lerpf(AOEMesh.scale.z, 4.56, delta * 6)
		if AOEMesh.scale.z == 4.56:
			firstGrowthCycleFinished = true
	else:
		AOEMesh.scale.x = lerpf(AOEMesh.scale.x, 0, delta * 6)
		AOEMesh.scale.y = lerpf(AOEMesh.scale.y, 0, delta * 6)
		AOEMesh.scale.z = lerpf(AOEMesh.scale.z, 0, delta * 6)
	if AOEMesh.scale.z == 0:
		queue_free()


func _on_life_span_timeout() -> void:
	Hurtbox.queue_free()
