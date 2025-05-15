extends Node3D

signal DataRecieved(data);
signal Connected();
signal Disconnected();

var client: ENetMultiplayerPeer = null;

func StartClient(ip: String, port: int):
	get_tree().set_multiplayer(SceneMultiplayer.new(), get_path()); # Allows you to have both Server and Client in one instance
	client = ENetMultiplayerPeer.new();
	
	var res := client.create_client(ip, port);
	multiplayer.multiplayer_peer = client;
	
	multiplayer.connected_to_server.connect(Connected.emit);
	multiplayer.server_disconnected.connect(Disconnected.emit);
	multiplayer.connection_failed.connect(Disconnected.emit);
	
	print("Client: " + error_string(res))
	
func SendData(data):
	
	TransferData.rpc_id(1, data);
	
	
	
@rpc("authority","call_remote", "reliable")
func TransferData(data):
	DataRecieved.emit(data);
