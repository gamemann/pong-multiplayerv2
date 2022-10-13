extends Node

func _host_server():
	var arguments = {}
	
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	
	NetVars.server = WebSocketServer.new()
	
	var err = NetVars.server.listen(arguments["port"], PoolStringArray(), 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		print("Host in use. Please try a different IP:Port.")
		
		return
		
	get_tree().set_network_peer(NetVars.server)
	
