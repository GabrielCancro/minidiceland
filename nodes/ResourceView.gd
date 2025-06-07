extends Control

func _ready() -> void:
	set_requisites()

func set_requisites(_reqs=["WO","FO"]):
	for n in $HBox.get_children(): 
		n.visible = n.get_index()<_reqs.size()
		if n.visible:
			n.texture = load("res://assets/dice/"+_reqs[n.get_index()]+".png")
