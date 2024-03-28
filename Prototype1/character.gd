extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_strength = 0
var direction = Vector2(0, 0).normalized()

func _physics_process(delta):
	var direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if(dash_strength < 1):
		direction = Vector2(direction_x, direction_y).normalized()
	
	if(Input.is_action_just_pressed("ui_accept") and dash_strength == 0):
		dash_strength = 30
	if (dash_strength > 0):
		dash_strength -= 1
	# Calculate the new velocity based on the direction and speed
	velocity = direction * SPEED * ((dash_strength / 15) + 1)
	
	#print(direction)
	#print(SPEED)
	#print(((dash_strength / 15) + 1))
	#print(Input.is_action_just_pressed("ui_accept"))
	if (Input.is_action_just_pressed("ui_accept", true)):
		print(Input.is_action_just_pressed("ui_accept", true))
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = Vector2(0, 0)
		dash_strength = 0
	move_and_slide()
