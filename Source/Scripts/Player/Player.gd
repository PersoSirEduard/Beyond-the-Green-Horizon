extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var MAX_SPEED = 4000
var ACCELERATION = 600
var FRICTION = 300
var health = 100

var attackDirection = Vector2.ZERO

enum {
	MOVE,
	ATTACK
}
var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $HitBoxPivot/HitBox

var weaponScript = load("res://Scripts/Player/Weapons/swordWeapon.gd")

func _ready():
	hitbox.set_script(weaponScript)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			hitbox.knockback = attackDirection * hitbox.knockbackForce
			attack_state(delta)

func move_state(delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	direction = direction.normalized()
	
	if (direction != Vector2.ZERO):
		attackDirection = direction
		animationState.travel("Run")
		animationTree.set("parameters/Run/blend_position", direction)
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Attack/blend_position", direction)
		velocity += direction * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK

func attack_state(delta):
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	health -= area.damage
	velocity += area.knockback
