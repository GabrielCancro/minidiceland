extends Node

var terrain_size = Vector2(128,128)
var MapNode:Node2D

var TERRAINS = ["forest","grass","desert","lagon","mountain"]

func init(map_node) -> void:
	MapNode = map_node

func generate_map(width,height):
	randomize()
	for t in MapNode.get_children(): t.queue_free()
	for x in range(width): for y in range(height):
		var t = preload("res://nodes/Terrain.tscn").instantiate()
		t.name = "terrain_"+str(x+1)+"_"+str(y+1)
		t.tile_pos = Vector2(x+1,y+1)
		t.set_type(TERRAINS[randi()%TERRAINS.size()])
		MapNode.add_child(t)
		t.position = terrain_size * Vector2(x,y)

func get_terrain(x,y):
	var terrain_name = "terrain_"+str(x)+"_"+str(y)
	return MapNode.get_node_or_null(terrain_name)
