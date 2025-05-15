extends Node3D

signal DataRecieved(sender, data);
signal Connected(id);
signal Disconnected(id);

var server: ENetMultiplayerPeer = null;

func StartServer(port: int, maxPlayers: int):
	get_tree().set_multiplayer(SceneMultiplayer.new(), get_path()); # Allows you to have both Server and Client in one instance
	server = ENetMultiplayerPeer.new();
	
	var res := server.create_server(port, maxPlayers);
	multiplayer.multiplayer_peer = server;
	
	multiplayer.peer_connected.connect(Connected.emit);
	multiplayer.peer_disconnected.connect(Disconnected.emit);
	
	
	print("Server: " + error_string(res))

func SendData(data, target := -1):
	if target > 1:
		TransferData.rpc_id(target, data);
	else:
		TransferData.rpc(data);

@rpc("any_peer","call_remote", "reliable")
func TransferData(data):
	DataRecieved.emit(multiplayer.get_remote_sender_id(), data);
