extends Node

@export var playerScene : PackedScene
@onready var Players : Node3D = $Players
@onready var spawnPoint : Node3D = $PlayerSpawnLocation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(add_player)
	

func add_player(id : int) -> void:
	if not multiplayer.is_server():
		return
	var player : = playerScene.instantiate()
	player.name = str(id)
	player.position = spawnPoint.position + Vector3(randf_range(-3, 3), 0, randf_range(-3, 3))
	Players.add_child(player)
	
func remove_player(id : int) -> void:
	if not multiplayer.is_server():
		return
	var player : = Players.get_node_or_null(str(id))
	if player:
		player.queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
