extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(6).text = Global.TeamAName
	self.get_child(7).text = Global.TeamBName
