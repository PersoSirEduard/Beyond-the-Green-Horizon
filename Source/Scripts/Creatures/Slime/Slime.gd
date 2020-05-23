extends KinematicBody2D

var velocity = Vector2.ZERO

export var damage = 5
export var health = 10
export var color = Color(0, 0, 0.5)
export var knockbackForce = 100
var MAX_SPEED = 2000
var ACCELERATION = 300
var FRICTION = 200
export var direction = Vector2.ZERO

enum {
	IDLE,
	CHASE,
	WANDER
}

var state = IDLE

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $PivotHitBox/HitBox
onready var playerDetectionZone = $PlayerDetectionZone
var isJumping = false

func _ready():
	sprite.modulate = color
	hitbox.damage = damage
	hitbox.knockbackForce = knockbackForce

func _physics_process(delta):
	
	match(state):
		IDLE:
			animationState.travel("Idle")
			if (isJumping == false):
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				direction = (player.global_position - global_position).normalized()
				var rdm_knockback = rand_range(0, 1)
				if (rdm_knockback <= 0.5):
					hitbox.knockback = direction * hitbox.knockbackForce
				else:
					hitbox.knockback = Vector2.ZERO
				animationState.travel("Move")
				animationTree.set("parameters/Move/blend_position", direction)
				animationTree.set("parameters/Idle/blend_position", direction)
				if (isJumping):
					velocity += direction * ACCELERATION * delta
					velocity = velocity.clamped(MAX_SPEED * delta)
			else:
				state = IDLE
	
	velocity = move_and_slide(velocity)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func start_jump():
	isJumping = true

func stop_jump():
	isJumping = false

func _on_HurtBox_area_entered(area):
	if (area.get("damage") && area.get("knockback")):
		
		health -= area.damage
		velocity += area.knockback
	if (health <= 0):
		queue_free()
