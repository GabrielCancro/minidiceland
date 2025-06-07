extends Sprite2D
class_name Terrain

var terrain_type = "GRASS"
var tile_pos:Vector2
var build = null
var added_dices = []

func _ready() -> void:
	$Button.focus_mode = 0
	Effector.add_hover($Button,_on_button_hover)
	$Button.connect("button_down",ActionManager.select_terrain.bind(self))
	set_build()

func set_type(_terrain_type = null):
	terrain_type = _terrain_type
	if terrain_type: $Terrain.texture = load("res://assets/terrain/"+terrain_type+".png")
	else: $Terrain.texture = null

func set_build(build_name=null):
	if build_name!=null && build == null: GameManager.inc_gamevar("buildings_amount",1)
	build = build_name
	if build: $Build.texture = load("res://assets/build/"+build+".png")
	else: $Build.texture = null

func _on_button_hover(val):
	if val: GameManager.set_hint(Lang.get_text("tx_terrain_"+terrain_type))
	else: GameManager.set_hint("")
	if val: scale = Vector2(1.1,1.1)
	else:  scale = Vector2(1,1)
