extends Control

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)

func _on_server_pressed() -> void:
	var err := NetworkManager.host()
	if err == OK:
		print("Hosting!")
	else:
		print("Couldn't host: ", error_string(err))

func _on_client_pressed() -> void:
	pass

func _on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)
