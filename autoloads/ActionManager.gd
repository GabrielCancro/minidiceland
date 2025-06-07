extends Node

var ActionPanel:ActionPanel
var CURRENT_AGE = 1
var ACTIONS = {
	"camp":{"req":["WO","FO"],"ico":"build/camp","conditions":{"terrain":null,"prebuild":"empty","age":null}},
	"farm":{"req":["WO","WO"],"ico":"build/farm","conditions":{"terrain":"grass","prebuild":"camp","age":null}},
	"mine":{"req":["WO","ST"],"ico":"build/mine","conditions":{"terrain":"mountain","prebuild":"camp","age":null}},
	"sawmill":{"req":["WO","ST"],"ico":"build/sawmill","conditions":{"terrain":"forest","prebuild":"camp","age":null}},
}


func init(action_panel) -> void:
	ActionPanel = action_panel
	for k in ACTIONS.keys(): ACTIONS[k]["name"] = k

func select_terrain(terrain_node):
	if terrain_node:
		print("SELECTED ", terrain_node)
		ActionPanel.set_terrain(terrain_node)
		GameManager.set_camera_to_terrain(terrain_node)
	else:
		ActionPanel.hide_panel()

func get_actions_by_terrain(terrain_node:Terrain):
	var actions = []
	for key in ACTIONS:
		var ac = ACTIONS[key]
		if ac.conditions.terrain != null:
			if ac.conditions.terrain != terrain_node.terrain_type: continue
		if ac.conditions.prebuild != null:
			if ac.conditions.prebuild == "empty":
				if terrain_node.build != null: continue
			else:
				if ac.conditions.prebuild != terrain_node.build: continue
		if ac.conditions.age != null:
			if ac.conditions.age > CURRENT_AGE: continue
		actions.append(ACTIONS[key])
	return actions

func cond_camp(): return (GameManager.get_gamevar("buildings_amount")<GameManager.get_gamevar("buildings_limit"))
func ac_camp():
	var t = ActionPanel.get_current_terrain()
	var dice = DiceManager.add_dice_by_terrain(t.terrain_type)
	t.added_dices.append(dice)
	t.set_build("camp")

func ac_farm():
	var t = ActionPanel.get_current_terrain()
	var dice = DiceManager.add_dice_by_terrain(t.terrain_type)
	t.added_dices.append(dice)
	t.set_build("farm")

func ac_mine():
	var t = ActionPanel.get_current_terrain()
	var dice = DiceManager.add_dice_by_terrain(t.terrain_type)
	t.added_dices.append(dice)
	t.set_build("mine")

func ac_sawmill():
	var t = ActionPanel.get_current_terrain()
	var dice = DiceManager.add_dice_by_terrain(t.terrain_type)
	t.added_dices.append(dice)
	t.set_build("sawmill")
