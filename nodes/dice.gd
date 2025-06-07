extends Control
class_name Dice

@onready var shader_material := $Sprite2D.material as ShaderMaterial
var tw:Tween
var ttl := 0.0
var end_tween_variance = 0.2
var is_floating = true
var faces = ["WO","FO","ST","LE","WO","GO"]
var result_index
var result_face
var is_stored_dice = false
var is_temporal_dice = false

func _ready():
	randomize()
	set_select(false)
	set_faces(faces)
	set_floating(true)
	$Label.text = ""
	shader_material.set_shader_parameter("initial_face", randi()%6)
	$btn_store.connect("button_down",DiceManager.on_click_dice_store.bind(self))

func set_faces(_faces):
	faces = _faces
	shader_material.set_shader_parameter("texture_pos_x", load("res://assets/dice/"+faces[0]+".png"))
	shader_material.set_shader_parameter("texture_neg_x", load("res://assets/dice/"+faces[1]+".png"))
	shader_material.set_shader_parameter("texture_pos_y", load("res://assets/dice/"+faces[3]+".png"))
	shader_material.set_shader_parameter("texture_neg_y", load("res://assets/dice/"+faces[2]+".png"))
	shader_material.set_shader_parameter("texture_pos_z", load("res://assets/dice/"+faces[5]+".png"))
	shader_material.set_shader_parameter("texture_neg_z", load("res://assets/dice/"+faces[4]+".png"))
	result_index = 0
	result_face = faces[result_index]

func roll():
	set_floating(false)
	set_exhausted(false)
	set_select(false)
	result_index = randi()%6
	result_face = faces[result_index]
	shader_material.set_shader_parameter("initial_face", result_index)
	ttl = randf_range(-10,-6)
	if is_instance_valid(tw): tw.kill()
	tw = create_tween()
	tw.tween_property(self, "ttl", randf_range(-end_tween_variance,+end_tween_variance), 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await(tw.finished)
	$Label.text = result_face
	update_ui()

func set_floating(val):
	$Label.text = ""
	is_floating = val
	if is_floating:
		set_select(false)
		set_exhausted(false)
		set_stored(false)
	if is_instance_valid(tw): tw.kill()
	update_ui()

func _process(delta):
	if is_floating: ttl += delta*2
	shader_material.set_shader_parameter("time", ttl)

func set_select(val):
	$ColorRect.visible = val

func is_selected():
	return $ColorRect.visible

func set_stored(val):
	is_stored_dice = val
	update_ui()

func is_stored():
	return is_stored_dice

func set_exhausted(val):
	if val: 
		modulate = Color(.3,.3,.3,1)
		shader_material.set_shader_parameter("opacity", 0.5)
		set_stored(false)
		if is_temporal(): remove_dice()
	else: 
		modulate = Color(1,1,1,1)
		shader_material.set_shader_parameter("opacity", 1.0)
		set_select(false)
	update_ui()

func set_temporal(val):
	if val: set_floating(false)
	is_temporal_dice = val
	update_ui()

func is_temporal():
	return is_temporal_dice

func is_exhausted():
	return (modulate.r<1)

func remove_dice():
	get_parent().remove_child(self)
	queue_free()
	
func get_result_face():
	return result_face

func update_ui():
	$Temporal.visible = is_temporal()
	$Stored.visible = is_stored()
