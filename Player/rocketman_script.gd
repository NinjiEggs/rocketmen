extends CharacterBody3D

# self
@onready var Self = $"."

# camera
@onready var Camera := $CameraPivot/Camera3D
@onready var Bomb := preload("res://Projectiles/Bomb.tscn")
var cameraMovement : bool = true

# cannon movement
@onready var bombProjectileSpawn := $CannonPivot/Cannon/CannonProjectileSpawn

# knockback
var applyingKnockback : bool = false
@onready var knockupTimer := $KnockupTimer
var knockIntensity : float
var knockingUp : bool = false
var lastKnockSource

### upgradeables
# movement upgradeables
const SPEED = 10.0
const JUMP_VELOCITY = 7
@export var maxAirJumps : int = 2
var currentAirJumps : int = maxAirJumps
var moveDisabled : bool = false
# statistic upgradeables
var maxHealth : float = 100
var currentHealth : float = maxHealth
# weapon upgradeables
# other upgradeables
var cannon

func _ready() -> void:
	if is_multiplayer_authority():
		$CameraPivot/Camera3D.make_current()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Shoot"):
		var bombToSpawn = Bomb.instantiate()
		bombProjectileSpawn.add_child(bombToSpawn)
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and currentAirJumps > 0:
		velocity.y = JUMP_VELOCITY
		if is_on_floor() == false:
			currentAirJumps -= 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var Direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Direction:
		Direction = Direction.rotated(Vector3.UP, Camera.global_rotation.y)
		velocity.x = Direction.x * SPEED
		velocity.z = Direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if knockingUp == true:
		velocity.y = knockIntensity
	
	if is_on_floor():
		currentAirJumps = maxAirJumps
	
	pass
	
	move_and_slide()

func applyKnockup(newTime : float, knockSource, Amount : float) -> void:
	knockingUp = true
	knockIntensity = Amount
	lastKnockSource = knockSource
	knockupTimer.wait_time = newTime
	knockupTimer.start()


func _on_knockup_timer_timeout() -> void:
	knockingUp = false
