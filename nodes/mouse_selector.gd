extends Control

var carried_node:Node2D = null
var carrier_offset = Vector2(40,40)

func _process(delta: float) -> void:
	var tlpos = get_node("/root/Game/TileMapLayer").local_to_map(get_global_mouse_position())
	set_position(Vector2(tlpos.x,tlpos.y)*size)
	if carried_node: carried_node.global_position = get_global_mouse_position() + carrier_offset

func set_carried_node(_node):
	carried_node = _node
