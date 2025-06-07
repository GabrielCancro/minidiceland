extends TileMapLayer
class_name TILE_TYPE
const DESERT = Vector2i(0,0)
const MEADOW = Vector2i(1,0)
const MOUNTAIN = Vector2i(2,0)
const FOREST = Vector2i(3,0)
const LAGON = Vector2i(4,0)
const FOG = Vector2i(5,0)
const RED = Vector2i(6,0)
const GREEN = Vector2i(7,0)
const CENTER = Vector2i(1,0)
const SHIPS = Vector2i(2,1)
const MINE = Vector2i(3,2)
const WOOD = Vector2i(4,3)

func set_building_mode(build_name) -> void:
	$TileMapLayerSelector.clear()
	if !build_name: return
	var all_tile_cells = get_used_cells()
	var source_id = $TileMapLayerSelector.tile_set.get_source_id(0)
	for i in all_tile_cells:
		var atlas_coord = get_cell_atlas_coords(i)
		if !atlas_coord in [TILE_TYPE.FOG]:
			if atlas_coord in [TILE_TYPE.LAGON]:
				$TileMapLayerSelector.set_cell(i, source_id,TILE_TYPE.RED)
			else:
				$TileMapLayerSelector.set_cell(i, source_id,TILE_TYPE.GREEN)

func is_green_tile(tile_pos) -> bool:
	return ($TileMapLayerSelector.get_cell_atlas_coords(tile_pos)==TILE_TYPE.GREEN)
