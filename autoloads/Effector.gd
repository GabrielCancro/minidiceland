extends Node

func move_to(node,destPos):
	var tw = create_tween()
	tw.tween_property(node, "position", destPos, .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func move_from(node,orgPos):
	var tw = create_tween()
	var destPos = node.position
	node.position = orgPos
	tw.tween_property(node, "position", destPos, .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func add_hover(node,calleable):
	if node.is_class("Button"): (node as Button).focus_mode = Control.FOCUS_NONE
	node.connect("mouse_entered",calleable.bind(true))
	node.connect("mouse_exited",calleable.bind(false))
