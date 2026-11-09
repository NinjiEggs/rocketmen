extends RigidBody3D

@export var projectileSpeed : float = 60
@onready var bombAOE := preload("res://Projectiles/BombAOE.tscn")
var bombAOEDamage : float = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reparent(get_tree().root)
	$".".scale = Vector3(1.0, 1.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0, projectileSpeed, 0) * delta

func spawnAOE() -> void:
	var AOEtoSpawn = bombAOE.instantiate()
	$".".add_child(AOEtoSpawn)
	$CollisionKillDelay.start()

func _on_lifespan_timeout() -> void:
	spawnAOE()


func _on_body_entered(body: Node) -> void:
	spawnAOE()


func _on_collision_kill_delay_timeout() -> void:
	queue_free()
