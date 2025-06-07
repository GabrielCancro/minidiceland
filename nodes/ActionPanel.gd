extends Node2D
class_name ActionPanel

var current_terrain:Terrain = null
var amount = 0
func _ready() -> void:
	hide_panel()
	rotate_fx()

func set_terrain(terrain_node):
	position = terrain_node.position
	z_index = terrain_node.z_index + 10
	current_terrain = terrain_node
	visible = true
	_generate_bubbles()

func get_current_terrain():
	return current_terrain

func _generate_bubbles():
	for b in $Bubbles.get_children(): b.queue_free()
	var actions = ActionManager.get_actions_by_terrain(current_terrain)
	amount = actions.size()
	for i in range(amount):
		var b = preload("res://nodes/ActionBubble.tscn").instantiate()
		$Bubbles.add_child(b)
		b.set_action(actions[i])
		var pos_i = i-amount/2
		if (amount%2==0): pos_i += .5
		var ang = -PI/2+(PI/5)*pos_i
		if amount>5: ang = -PI/2+(PI/amount)*pos_i
		var pos = 150*Vector2(cos(ang),sin(ang))
		Effector.move_to(b,pos)

func hide_panel():
	current_terrain = null
	visible = false

func rotate_fx():
	$Selector.rotation_degrees += 90
	await get_tree().create_timer(.5).timeout
	rotate_fx()
