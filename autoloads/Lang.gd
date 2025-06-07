extends Node

var current_lang = "es"
var LOCALIZATED = {
"es":{
	"tx_terrain_grass":"Planicie, terreno fertil perfecto para la agricultura en general.",
	"tx_terrain_forest":"Bosque, los arboles te permiten recolectar madera y quezas algo de carbon.",
	"tx_terrain_mountain":"Montania, ideal para edificar minas y extraer preciados metales.",
	"tx_terrain_hill":"Colinas, no tiene mucha utilidad aun.",
	"tx_terrain_lagon":"Lago, algun dia podras construir barcos de pesca.",
	
	"tx_build_camp":"Campamento, otorga 1 dado de recurso, el tipo de dado varia segun el terreno donde lo construyas.",
	"tx_build_center":"Centro de aldea, otorga 2 dados variados.",
	"tx_build_farm":"Granja, otorga 1 dado de alimento.",
	"tx_build_mine":"Mina, otorga 1 dado de metales.",
	"tx_build_sawmill":"Aserradero, otorga un dado de madera.",
	"tx_":"",
}}

func get_text(code):
	if !code in LOCALIZATED[current_lang]: return code
	return LOCALIZATED[current_lang][code]
