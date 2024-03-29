extends Area2D

var frames = 0

func _ready():
	pass

func _process(delta):
	if self.visible:
		if frames == 0: frames = 15
		else: frames -= 1
		self.rotation += delta * 8
		if frames == 0:
			visible = false
			rotation = 0

func check_colissions():
	if visible and get_overlapping_bodies().size() > 0:
		return true
	return false
	
func isUsable():
	if !visible and get_overlapping_bodies().size() > 0:
		return false
	return true

	
	
