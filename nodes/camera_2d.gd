extends Camera2D

var pos:Vector2 = Vector2()

func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	set_camera_position(3,3)

func set_camera_position(x:int, y:int):
	var node = MapManager.get_terrain(x,y)
	print("have node! ", node,"   ",x,",",y)
	if node: 
		pos = Vector2(x,y)
		position = node.position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"): set_camera_position(pos.x,pos.y-1)
	if Input.is_action_just_pressed("down"): set_camera_position(pos.x,pos.y+1)
	if Input.is_action_just_pressed("left"): set_camera_position(pos.x-1,pos.y)
	if Input.is_action_just_pressed("right"): set_camera_position(pos.x+1,pos.y)
	
