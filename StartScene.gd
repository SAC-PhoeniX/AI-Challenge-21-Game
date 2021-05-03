extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		Global.TeamAName = self.get_child(1).text
		Global.TeamBName = self.get_child(2).text
		Global.TeamANumber = self.get_child(3).text
		Global.TeamBNumber = self.get_child(4).text
		get_tree().change_scene("res://MapC.tscn")
