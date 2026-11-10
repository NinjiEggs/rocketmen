extends Control

var debug_timer := 0.0

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
func _process(delta: float) -> void:
	debug_timer += delta
	if debug_timer >= 1.0:
		debug_timer = 0.0
		if multiplayer.multiplayer_peer == null:
			print("Status: peer is null")
		else:
			print("Status: ", multiplayer.multiplayer_peer.get_connection_status())

func _on_server_pressed() -> void:
	var err := NetworkManager.host()
	if err == OK:
		print("Hosting!")
		get_parent().add_player(1)
		queue_free()
	else:
		print("Couldn't host: ", error_string(err))

func _on_client_pressed() -> void:
	var err := NetworkManager.join("127.0.0.1")
	print("join() returned: ", error_string(err))

func _on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)

func _on_connected() -> void:
	print("Joined")
	queue_free()

func _on_connection_failed() -> void:
	print("Couldn't join.")
	multiplayer.multiplayer_peer = null
