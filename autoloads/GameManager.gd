extends Node

var scene:Node = null
var GAME_VARS = {
	"buildings_amount" = 0,
	"buildings_limit" = 4,
	"store_amount" = 0,
	"store_limit" = 1,
	"dices" = 0,
	"days" = 0,
	"age" = 1,
}

func init(_scene:Node):
	scene = _scene
	update_ui()

func get_mouse_tile():
	return scene.get_node("TileMapLayer").local_to_map(scene.get_global_mouse_position())

func set_hint(text):
	scene.get_node("UI/RHintLabel").text = text

func set_camera_to_terrain(terrain_node):
	scene.get_node("Camera2D").set_camera_position(terrain_node.tile_pos.x,terrain_node.tile_pos.y)

func get_gamevar(key):
	return GAME_VARS[key]

func set_gamevar(key,value):
	GAME_VARS[key] = value
	update_ui()

func inc_gamevar(key,value):
	set_gamevar(key,GAME_VARS[key]+value)

func update_ui():
	if !scene: return
	var str = "AGE "+str(get_gamevar("age")) + "    DAY "+str(get_gamevar("days")) + ", Primavera"
	str += "\n"+ "Builds "+str(get_gamevar("buildings_amount"))+"/"+str(get_gamevar("buildings_limit"))
	str += "    "+ "Store "+str(get_gamevar("store_amount"))+"/"+str(get_gamevar("store_limit"))
	str += "    "+ "Dices "+str(get_gamevar("dices"))
	scene.get_node("UI/GameUI/Label").text = str
	
