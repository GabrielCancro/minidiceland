extends Node2D

const tile_size = 96

func _ready() -> void:
	$Camera2D.position = Vector2(tile_size*7-tile_size/2,tile_size*4-tile_size/2)
	$UI/btn_roll.connect("button_down",DiceManager.roll_all_dices)
	$UI/btn_floating.connect("button_down",DiceManager.floating_dices)
	$UI/btn_exahuste.connect("button_down",DiceManager.exhauste_all_dices)
	$UI/btn_add_temp.connect("button_down", (func(): DiceManager.add_temporal_dice("WO")) )
	GameManager.init(self)
	DiceManager.init($UI/Dices)
	ActionManager.init($ActionPanel)
	MapManager.init($Map)
	MapManager.generate_map(5,3)
	MapManager.get_terrain(3,2).set_build("center")
	await get_tree().create_timer(1).timeout

func _input(event):
	pass
