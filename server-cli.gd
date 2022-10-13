extends Control

func _ready():
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
	
func _process(delta):
	# We can process commands later on!
	pass
