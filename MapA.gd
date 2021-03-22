extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(6).text = Global.TeamAName
	self.get_child(7).text = Global.TeamBName
	$HTTPRequest.connect("request_completed", self, "_http_request_completed")

func _http_request_completed(result, response_code, headers, body):
	pass #print("rc: "+str(response_code)+", result: "+str(result),", body: "+body.get_string_from_utf8())

func _process(delta):
	var projectiles = {}
	var tankA = {}
	var tankB = {}
	for child in self.get_children():
		if "TankA" in child.name:
			var degreerotation = -int(child.rotation * 180 / PI)
			tankA = {"x":str(int(child.position.x)), "y":str(int(child.position.y)), "r": str(degreerotation)}
		if "TankB" in child.name:
			var degreerotation = -int(child.rotation * 180 / PI)
			tankB = {"x":str(int(child.position.x)), "y":str(int(child.position.y)), "r": str(degreerotation)}
	var projectile_n = 0
	for child in get_tree().get_root().get_children():
		if "Projectile" in child.name:
			var projectile = {"x": str(int(child.position.x)), "y":str(int(child.position.y)), "vx":int(child.linear_velocity.x),"vy":int(child.linear_velocity.y)}
			projectiles["p"+str(projectile_n)]=projectile
			projectile_n += 1
	var dataToSend = {"tankA": tankA, "tankB": tankB, "projectiles":projectiles}
	_make_post_request("http://localhost:3000/", dataToSend, false)

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)

	# Add 'Content-Type' header:
	var headers = ["Content-Type: text/html", "Content-Length: "+str(query.length())]
	$HTTPRequest.request(url+"?"+query, headers, use_ssl, HTTPClient.METHOD_POST)
