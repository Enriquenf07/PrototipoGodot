extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_strength = 0
var direction = Vector2(0, 0).normalized()
@onready
var sword = get_node("Sword")
enum MOVE_SET {LEFT, RIGHT, UP, DOWN, LEFT_UP, LEFT_DOWN, RIGHT_UP, RIGHT_DOWN}
var direction_state = MOVE_SET.DOWN

func _ready():
	sword.visible = false

func attack():
	if sword.isUsable():
		sword.visible = true
		
func dash():
	dash_strength = 15
		
func handle_dash(direction_x, direction_y):
	if(dash_strength < 1):
		direction = Vector2(direction_x, direction_y).normalized()
	if (dash_strength > 0):
		dash_strength -= 1
	return dash_strength * 40
	
func handle_character_direction(last_state):
	if velocity.x > 0 and velocity.y > 0:
		return MOVE_SET.RIGHT_DOWN
	if velocity.x > 0 and velocity.y < 0:
		return MOVE_SET.RIGHT_UP
	if velocity.x < 0 and velocity.y > 0:
		return MOVE_SET.LEFT_DOWN
	if velocity.x < 0 and velocity.y < 0:
		return MOVE_SET.LEFT_UP
	if velocity.x < 0 and velocity.y == 0:
		return MOVE_SET.LEFT
	if velocity.x > 0 and velocity.y == 0:
		return MOVE_SET.RIGHT
	if velocity.x == 0 and velocity.y > 0:
		return MOVE_SET.DOWN
	if velocity.x == 0 and velocity.y < 0:
		return MOVE_SET.UP
	return last_state
	
func comeback():
	var comeback_distance = 300
	var direction_map = {
		MOVE_SET.UP: Vector2(0, comeback_distance),
		MOVE_SET.DOWN: Vector2(0, -comeback_distance),
		MOVE_SET.LEFT: Vector2(comeback_distance, 0),
		MOVE_SET.RIGHT: Vector2(-comeback_distance, 0),
		MOVE_SET.LEFT_UP: Vector2(comeback_distance, comeback_distance),
		MOVE_SET.LEFT_DOWN: Vector2(comeback_distance, -comeback_distance),
		MOVE_SET.RIGHT_UP: Vector2(-comeback_distance, comeback_distance),
		MOVE_SET.RIGHT_DOWN: Vector2(-comeback_distance, -comeback_distance)
	}
	if direction_state in direction_map:
		velocity = direction_map[direction_state]
func move_character(delta):
	var direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var dash_speed = handle_dash(direction_x, direction_y)
	velocity = direction * (SPEED + dash_speed)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = Vector2(0, 0)
		dash_strength = 0
	direction_state = handle_character_direction(direction_state)
	if sword.check_colissions():
		comeback()
	move_and_slide()

func _input(event):
	if event.is_action_pressed("dash") and dash_strength == 0:
		dash()
	if event.is_action_pressed("lt_attack") and dash_strength == 0:
		attack()

func _physics_process(delta):
	move_character(delta)
	
