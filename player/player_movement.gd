extends CharacterBody3D

enum PlayerState {
	walking,
	running,
	crouching
}

var player_state: PlayerState

var movement_speed
var walk_movement_speed = 4
var run_movement_speed = 6
var crouch_movement_speed = 2

var horizontal_acceleration
var horizontal_air_acceleration = 2
var horizontal_normal_acceleration = 11

var gravity = 15.5
var jump_force = 6

var direction: Vector3
var horizontal_velocity = Vector3()
var gravity_vector = Vector3()

func _physics_process(delta):
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_direction.x, 0,input_direction.y )).normalized()
	
	if not is_on_floor():
		gravity_vector += Vector3.DOWN * gravity * delta
		horizontal_acceleration = horizontal_air_acceleration
	else:
		gravity_vector = -get_floor_normal()
		horizontal_acceleration = horizontal_normal_acceleration
	
	if is_on_ceiling():
		gravity_vector = Vector3(0,-0.1,0)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vector = Vector3.UP * jump_force
	
	if Input.is_action_pressed("run"):
		movement_speed = run_movement_speed
		player_state = PlayerState.running
	else: 
		movement_speed = walk_movement_speed
		player_state = PlayerState.walking
	
	crouch(delta)
	
	direction = direction.normalized()
	horizontal_velocity = horizontal_velocity.lerp(direction * movement_speed, horizontal_acceleration * delta)
	velocity.z = horizontal_velocity.z + gravity_vector.z
	velocity.x = horizontal_velocity.x + gravity_vector.x
	velocity.y = gravity_vector.y
	
	move_and_slide()

@onready var player_collision_shape = $CollisionShape3D
@onready var player_head = $Head

@onready var head_raycast = $HeadRayCast

func crouch(delta):
	var lerp_speed = 12
	
	var initial_player_height = 1.8
	var crouching_player_height = 1.0
	
	var initial_camera_height = 1.4
	
	if Input.is_action_pressed("crouch"):
		player_state = PlayerState.crouching
		movement_speed = crouch_movement_speed
		
		player_collision_shape.shape.height = lerp(player_collision_shape.shape.height, crouching_player_height, delta * lerp_speed)
		player_head.position.y = lerp(player_head.position.y, (initial_player_height-crouching_player_height) / 2 + (crouching_player_height / 4) * 3, delta * lerp_speed)
		head_raycast.position.y = lerp(head_raycast.position.y, (initial_player_height-crouching_player_height) / 2 + crouching_player_height, delta * lerp_speed)
	elif !head_raycast.is_colliding():
		player_collision_shape.shape.height = lerp(player_collision_shape.shape.height, initial_player_height, delta * lerp_speed)
		player_head.position.y = lerp(player_head.position.y, initial_camera_height, delta * lerp_speed)
		head_raycast.position.y = lerp(head_raycast.position.y, initial_player_height, delta * lerp_speed)
	
	if head_raycast.is_colliding() and is_on_floor():
		player_state = PlayerState.crouching
		movement_speed = crouch_movement_speed










