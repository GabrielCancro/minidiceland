extends Node

var DICES_BY_TERRAIN = {
	"basic" = ["FO","FO","WO","WO","ST","ZZ"],
	"grass" = ["FO","FO","FO","FO","LE","ZZ"],
	"forest" = ["WO","WO","WO","WO","CA","ZZ"],
	"lagon" = ["FO","FO","FO","GO","ZZ","ZZ"],
	"desert" = ["GO","GO","GO","ZZ","ZZ","ZZ"],
	"mountain" = ["ST","ST","ST","ST","ME","ZZ"],
}

var DICES:Control
var cheking_requisites

func init(dices_node):
	DICES = dices_node
	for d in DICES.get_children(): d.queue_free()
	GameManager.set_gamevar("dices",0)
	add_dice_by_terrain("basic")
	add_dice_by_terrain("grass")
	add_dice_by_terrain("forest")
	order_dices()

func roll_all_dices():
	GameManager.inc_gamevar("days",1)
	for d in DICES.get_children(): if !d.is_stored(): d.roll()
	order_dices()
	#await get_tree().create_timer(1.2).timeout
	#for d in DICES.get_children(): if d.is_stored(): d.set_stored(false)
	#order_dices()

func exhauste_all_dices():
	for d in DICES.get_children(): if !d.is_stored(): d.set_exhausted(true)
	order_dices()

func floating_dices():
	for d in DICES.get_children():
		d.set_floating(true)

func check_requisites(req=[]):
	#req = ["GO","GO","ST"]
	var dices_used = []
	clear_requisites()
	for k in req:
		for d:Dice in DICES.get_children(): 
			if !d.is_selected() && d.get_result_face() == k:
				d.set_select(true)
				dices_used.append(d)
				break
	var result = (req.size()==dices_used.size())
	if !result: for d in dices_used: d.set_select(false)
	return result

func consume_requisites():
	var result = false
	for d:Dice in DICES.get_children(): 
		if d.is_selected(): 
			result = true
			d.set_exhausted(true)
	order_dices()
	return result

func clear_requisites():
	for d in DICES.get_children(): d.set_select(false)

func order_dices():
	var index_availables = 0
	var index_exhausted = 0
	
	#PRE ORDER
	var priority_arrays = [[],[],[],[]]
	var EXHAUSTED_DICES = []
	for d:Dice in DICES.get_children():
		if d.is_exhausted(): EXHAUSTED_DICES.append(d)
		if !d.is_stored() && d.is_temporal(): priority_arrays[0].append(d)
		elif !d.is_stored() && !d.is_temporal(): priority_arrays[1].append(d)
		else: priority_arrays[2].append(d)
	var DICES_ARRAY = priority_arrays[0]+priority_arrays[1]+priority_arrays[2]+priority_arrays[3]
	
	const space = 90
	for i in range(DICES_ARRAY.size()):
		var d:Dice = DICES_ARRAY[i]
		DICES.move_child(d,i)
		var index = d.get_index()
		Effector.move_to(d,Vector2(space + (index % 6) * space,floor(index/6) * space))
	
	for d:Dice in EXHAUSTED_DICES: 
		var index = d.get_index()
		Effector.move_to(d,Vector2(1600 - space - (index % 6) * space,floor(index/6) * space))

func on_click_dice_store(dice):
	if dice.is_exhausted(): return
	if dice.is_stored():
		GameManager.inc_gamevar("store_amount",-1)
		dice.set_stored(false)
	else: if GameManager.get_gamevar("store_amount")<GameManager.get_gamevar("store_limit"):
		GameManager.inc_gamevar("store_amount",+1)
		dice.set_stored(true)
	DiceManager.order_dices()
	print("STORE CLICK!! ",dice.is_stored())

func add_dice(faces):
	var dice_node = preload("res://nodes/dice.tscn").instantiate()
	DICES.add_child(dice_node)
	dice_node.set_faces(faces)
	dice_node.set_exhausted(true)
	DiceManager.order_dices()
	return dice_node

func add_temporal_dice(one_face):
	var dice_node = preload("res://nodes/dice.tscn").instantiate()
	DICES.add_child(dice_node)
	dice_node.set_faces([one_face,one_face,one_face,one_face,one_face,one_face])
	dice_node.set_temporal(true)
	DiceManager.order_dices()
	return dice_node

func add_dice_by_terrain(terrain_type):
	GameManager.inc_gamevar("dices",1)
	var dice = add_dice( DICES_BY_TERRAIN[terrain_type] )
	return dice
