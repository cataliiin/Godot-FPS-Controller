extends Node3D

@export_node_path("Node3D") var head_nodepath
@export_node_path("CharacterBody3D") var player_nodepath
var mouse_sensitivity = 0.03
var mouse_smoothness = 20

var camera_input : Vector2
var rotation_velocity : Vector2

@onready var head = get_node(head_nodepath)
@onready var player = get_node(player_nodepath)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_input = event.relative
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	rotation_velocity = rotation_velocity.lerp(camera_input * mouse_sensitivity, delta * mouse_smoothness)
	player.rotate_y(deg_to_rad(-rotation_velocity.x))
	head.rotate_x(deg_to_rad(-rotation_velocity.y))
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	camera_input = Vector2.ZERO

func _physics_process(delta):
	head_boobing(delta)

# HEAD BOOBING

const hb_lerp_speed = 10.0

const hb_running_speed = 18.0
const hb_walking_speed = 14.0
const hb_crouching_speed = 10.0

const hb_running_intensity = 0.12
const hb_walking_intensity = 0.05
const hb_crouching_intensity = 0.05

var hb_vector = Vector2.ZERO
var hb_index = 0.0
var hb_current_intensity = 0.0

@onready var player_eyes = $".."

func head_boobing(delta):
	
	match player.player_state:
		player.PlayerState.running:
			hb_current_intensity = hb_running_intensity
			hb_index += hb_running_speed * delta
		player.PlayerState.walking:
			hb_current_intensity = hb_walking_intensity
			hb_index += hb_walking_speed * delta
		player.PlayerState.crouching:
			hb_current_intensity = hb_crouching_intensity
			hb_index += hb_crouching_speed * delta
	
	if player.is_on_floor() and player.direction != Vector3.ZERO:
		hb_vector.y = sin(hb_index)
		hb_vector.x = sin(hb_index/2)+0.5
		
		player_eyes.position.y = lerp(player_eyes.position.y, hb_vector.y * (hb_current_intensity/2), delta * hb_lerp_speed)
		player_eyes.position.x = lerp(player_eyes.position.x, hb_vector.x * hb_current_intensity, delta * hb_lerp_speed)
	else:
		player_eyes.position.y = lerp(player_eyes.position.y,0.0 , delta * hb_lerp_speed)
		player_eyes.position.x = lerp(player_eyes.position.x,0.0 , delta * hb_lerp_speed)
