extends Control

func _ready():
	# Connect all the callbacks related to networking.
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	# Set default host info.
	var ip = "127.0.0.1"
	var port = int(rand_range(1025, 65535))
	
	# Loop through command arguments.
	var arguments = {}
	
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
			
	if arguments.has("ip"):
		ip = str(arguments["ip"])
		
	if arguments.has("port"):
		port = int(arguments["port"])
	
	NetVars.server = WebSocketServer.new()
	
	var err = NetVars.server.listen(port, PoolStringArray(), 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		print("Host in use. Please try a different IP:Port.")
		
		return
		
	get_tree().set_network_peer(NetVars.server)


func _player_connected(_id):
	# Someone connected, start the game!
	var pong = load("res://pong.tscn").instance()
	# Connect deferred so we can safely erase it from the callback.
	pong.connect("game_finished", self, "_end_game", [], CONNECT_DEFERRED)

	get_tree().get_root().add_child(pong)
	hide()

func _player_disconnected(_id):
	print("Client disconnected")

func _end_game(with_error = ""):
	if has_node("/root/Pong"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node("/root/Pong").free()
		show()

	get_tree().set_network_peer(null) # Remove peer.
	print(with_error)

func _process(delta):
	# We can process commands later on!
	pass
