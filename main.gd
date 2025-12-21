extends Node3D

@export var target_scene: PackedScene

# Look
@export var sensitivity := 0.12
@export var touch_sensitivity := 0.10

@onready var camera: Camera3D = $Camera3D
@onready var targets_node: Node3D = $Targets
@onready var score_label: Label = $UI/ScoreLabel
@onready var timer_label: Label = $UI/TimerLabel
@onready var accuracy_label: Label = $UI/AccuracyLabel

# End Screen
@onready var end_screen: ColorRect = $UI/EndScreen
@onready var final_score_label: Label = $UI/EndScreen/EndBox/FinalScoreLabel
@onready var final_acc_label: Label = $UI/EndScreen/EndBox/FinalAccLabel

# Game state
var score := 0
var time_left := 30.0
var game_over := false

# Accuracy tracking
var shots := 0
var hits := 0

# Pitch clamp state
var pitch := 0.0

# Spawn positions (Gridshot-style)
var positions = [
	Vector3(-1, 1, 0),
	Vector3(0, 1, 0),
	Vector3(1, 1, 0),
	Vector3(-1, 1.5, 0),
	Vector3(1, 1.5, 0)
]


func _ready():
	if target_scene == null:
		push_error("Target Scene not assigned in Inspector.")
		return

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Init pitch from current camera rotation
	pitch = camera.rotation_degrees.x

	score = 0
	shots = 0
	hits = 0
	time_left = 30.0
	game_over = false

	update_score_label()
	update_timer_label()
	update_accuracy_label()

	if end_screen:
		end_screen.visible = false

	spawn_target()


func _process(delta):
	if game_over:
		return

	time_left -= delta
	
	if time_left <= 0.0:
		time_left = 0.0
		game_over = true
		
		update_timer_label()
		show_end_screen()
		
		return

	update_timer_label()


func _input(event):
	# ESC releases cursor
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if game_over:
		return

	# PC: mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		apply_look(event.relative.x, event.relative.y)

	# Mobile: finger drag look
	if event is InputEventScreenDrag:
		apply_look(event.relative.x * touch_sensitivity, event.relative.y * touch_sensitivity)

	# PC: left click = shoot from crosshair center
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shots += 1
		update_accuracy_label()
		shoot(get_screen_center())

	# Mobile: tap anywhere = shoot from crosshair center
	if event is InputEventScreenTouch and event.pressed:
		shots += 1
		update_accuracy_label()
		shoot(get_screen_center())


func apply_look(delta_x: float, delta_y: float):
	# Yaw (left/right) directly on the camera
	camera.rotation_degrees.y -= delta_x * sensitivity

	# Pitch (up/down) with clamp
	pitch -= delta_y * sensitivity
	pitch = clamp(pitch, -80.0, 80.0)
	camera.rotation_degrees.x = pitch


func get_screen_center() -> Vector2:
	return get_viewport().get_visible_rect().size * 0.5


func spawn_target():
	# Keep only one target active
	for c in targets_node.get_children():
		c.queue_free()

	var t = target_scene.instantiate()
	targets_node.add_child(t)
	t.position = positions.pick_random()


func shoot(screen_pos: Vector2):
	var from = camera.project_ray_origin(screen_pos)
	var to = from + camera.project_ray_normal(screen_pos) * 100.0

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result and result.collider and result.collider.is_in_group("target"):
		hits += 1
		score += 1

		update_score_label()
		update_accuracy_label()

		if result.collider.has_method("hit"):
			result.collider.hit()
		else:
			result.collider.queue_free()

		spawn_target()


func update_score_label():
	score_label.text = "Score " + str(score)


func update_timer_label():
	timer_label.text = "Timer " + str(int(ceil(time_left)))


func update_accuracy_label():
	if shots == 0:
		accuracy_label.text = "Accuracy 100 %"
		return

	var acc = (float(hits) / float(shots)) * 100.0
	accuracy_label.text = "Accuracy " + str(int(round(acc))) + " %"


func show_end_screen():
	if end_screen == null:
		return

	end_screen.visible = true
	final_score_label.text = "Score " + str(score)

	var acc := 0
	if shots > 0:
		acc = int(round((float(hits) / float(shots)) * 100.0))

	final_acc_label.text = "Accuracy " + str(acc) + " %"
