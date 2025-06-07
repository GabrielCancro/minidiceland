extends Node2D
var action_data

func set_action(_action_data):
	action_data = _action_data
	$Label.text = action_data.name
	Effector.add_hover($Button,_on_button_hover)
	$Button.connect("button_down",_on_button_click)
	$Ico.texture = load("res://assets/"+action_data.ico+".png")
	$ResourceView.set_requisites(action_data.req)

func _on_button_hover(val):
	if val: 
		GameManager.set_hint(Lang.get_text("tx_build_"+action_data.name)+"\n"+str(action_data.req))
		scale = Vector2(1.1,1.1)
		DiceManager.check_requisites(action_data.req)
	else: 
		GameManager.set_hint("")
		scale = Vector2(1,1)
		DiceManager.clear_requisites()

func _on_button_click():
	var ac_condition = false
	if ActionManager.has_method("cond_"+action_data.name):
		if ActionManager.call("cond_"+action_data.name) == false: return
	var result = DiceManager.consume_requisites()
	if result:
		ActionManager.call("ac_"+action_data.name)
		ActionManager.select_terrain(null)
