extends KinematicBody2D

export var MAX_SPEED = 100
export var ROLL_SPEED = 200
export var ACCELERATION = 500
export var FRICTION = 500

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var rollTimer = $AttackTimer
onready var attackTimer = $AttackTimer
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $Hitbox

enum {
	NONE, MOVE, ROLL, ATTACK
}

var velocity = Vector2.ZERO
var state = NONE
var can_roll = true

func _ready():
	animationTree.active = true
	state = MOVE

func _process(delta):
	match (state):
		MOVE:
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
			elif Input.is_action_just_pressed("roll") && can_roll:
				animationState.travel("Roll")
				rollTimer.start()
				state = ROLL
			else:
				move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state()
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

func roll_state(delta):
	var direction = animationTree.get("parameters/Roll/blend_position")
	velocity = velocity.move_toward(direction * ROLL_SPEED, ROLL_SPEED * delta)
	velocity = move_and_slide(velocity)
	
func _on_roll_timer_timeout():
	state = MOVE

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	attackTimer.start()
	state = NONE

func _on_attack_timer_timeout():
	state = MOVE

func set_can_roll(can_roll):
	self.can_roll = can_roll
	
func reset_velocity():
	velocity = Vector2.ZERO

func set_acceleration(acceleration):
	ACCELERATION = acceleration


func enable_hitbox():
	hitbox.visible = true
	hitbox.monitorable = true
	hitbox.monitoring = true

func disable_hitbox():
	hitbox.visible = false
	hitbox.monitorable = false
	hitbox.monitoring = false
