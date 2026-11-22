extends CharacterBody3D


const SPEED = 2.5
const ACCELERATION = 20
const JUMP_VELOCITY = 3
const MOUSE_SENSITIVITY = 0.002

@onready var camera: Camera3D = $Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	# Mausbewegung → umschauen
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Yaw (links/rechts) dreht den ganzen Körper
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		# Pitch (hoch/runter) dreht nur die Kamera
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# Pitch begrenzen, damit man nicht rückwärts kippt
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)

	# ESC gibt die Maus frei
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Beschleunigung 
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		# Abbremsen
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)

	move_and_slide()
