extends Node2D

func _ready():
	self.get_child(1).text = Global.TeamAName
	self.get_child(2).text = str(Global.TeamAScore)
	self.get_child(3).text = Global.TeamBName
	self.get_child(4).text = str(Global.TeamBScore)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		Global.TeamAName = ""
		Global.TeamBName = ""
		Global.TeamAScore = 0
		Global.TeamBScore = 0
		Global.TeamANumber = ""
		Global.TeamBNumber = ""
		Global.TeamACanFire = true
		Global.TeamBCanFire = true
		get_tree().change_scene("res://StartScene.tscn")
