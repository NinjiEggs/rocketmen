extends CharacterBody3D

# self
@onready var Self = $"."

# camera
@onready var Camera := $CameraPivot/Camera3D
@onready var Bomb := preload("res://Projectiles/Bomb.tscn")
var cameraMovement : bool = true

# cannon movement
@onready var bombProjectileSpawn := $Weapons/CannonPivot/Cannon/CannonProjectileSpawn

# knockback
var applyingKnockback : bool = false
@onready var knockupTimer := $KnockupTimer
var knockIntensity : float
var knockingUp : bool = false
var lastKnockSource

# other
var currentWeaponIndex : int = 1

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
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_pressed("Aim"):
		match currentWeaponIndex:
			1:
				$CameraPivot/Camera3D.make_current()
			2:
				$Weapons/SniperPivot/Sniper/Camera3D.make_current()
	else:
		$CameraPivot/Camera3D.make_current()
	
		
	if Input.is_action_just_pressed("Swap"):
		if currentWeaponIndex == 1:
			currentWeaponIndex = 2
			$Weapons/CannonPivot.visible = false
			$Weapons/SniperPivot.visible = true
			print ("Weapon Index: ",currentWeaponIndex)
		elif currentWeaponIndex == 2:
			currentWeaponIndex = 1
			$Weapons/CannonPivot.visible = true
			$Weapons/SniperPivot.visible = false
			print ("Weapon Index: ",currentWeaponIndex)
	
	if Input.is_action_just_pressed("Shoot"):
		match currentWeaponIndex:
			1:
				shootBomb.rpc_id(1, bombProjectileSpawn.global_position, bombProjectileSpawn.global_rotation)
			2:
				if $Weapons/SniperPivot/Sniper/RayCast3D.is_colliding():
					var collidingPlayer = $Weapons/SniperPivot/Sniper/RayCast3D.get_collider()
					print ("SNIPE!")
		
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
	
	move_and_slide()

func applyKnockup(newTime : float, knockSource, Amount : float) -> void:
	knockingUp = true
	knockIntensity = Amount
	lastKnockSource = knockSource
	knockupTimer.wait_time = newTime
	knockupTimer.start()


func _on_knockup_timer_timeout() -> void:
	knockingUp = false

@rpc("any_peer", "call_local", "reliable") 
func shootBomb(spawn_position: Vector3, spawn_rotation: Vector3) -> void:
	if not multiplayer.is_server():
		return
	if multiplayer.get_remote_sender_id() != get_multiplayer_authority():
		return
	var bomb := Bomb.instantiate()
	bomb.position = spawn_position
	bomb.rotation = spawn_rotation
	
	get_tree().current_scene.get_node("Projectiles").add_child(bomb, true)
	
