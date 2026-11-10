extends Control

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_server_pressed() -> void:
	var err := NetworkManager.host()
	if err == OK:
		print("Hosting!")
	else:
		print("Couldn't host: ", error_string(err))

func _on_client_pressed() -> void:
	NetworkManager.join("127.0.0.1")

func _on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)

func _on_connected() -> void:
	print("Joined")

func _on_connection_failed() -> void:
	multiplayer.multiplayer_peer = null
	print("Couldn't join.")
