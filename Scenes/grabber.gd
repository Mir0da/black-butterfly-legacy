extends Node3D
#Spieler kann Gegenstand aufnehmen und wegschmeißen!

@export var hold_speed :=15.0 #Schneel Hand folgen
@export var throw_speed := 4.0 #Starker Wurf?

#Kind-Nodes und Spieler, beim Start holen
@onready var ray: RayCast3D = $InteractRay #Augen: was schaue ich an
@onready var hold_point: Marker3D = $HoldPoint #Griff
@onready var player := owner as CollisionObject3D #Root

var heldItem: Item = null

func _ready() -> void:
	ray.add_exception(player)
	
func _unhandled_input(event: InputEvent) -> void:
	#E macht aufheben
	if event.is_action_pressed("interact") and heldItem == null:
		try_pick_up()
	#Q schmeißt das Objekt
	elif event.is_action_pressed("throw") and heldItem:
		throw_held()
		

func _physics_process(delta: float) -> void:
	#Gehaltenes Item angenehm zum HoldPoint ziehen
	if heldItem:
		var weight := clampf(hold_speed * delta, 0.0, 1.0)
		heldItem.global_transform = heldItem.global_transform.interpolate_with(hold_point.global_transform, weight)
		
func try_pick_up() -> void:
	#Wenn Strahl (dieser Raycast) nichts trifft dann abbrechen
	if not ray.is_colliding():
		return
	var item := ray.get_collider() as Item
	if item == null:
		return 
	heldItem = item
	#Damit pausiert man die Physics, solange es gehalten wird
	heldItem.freeze = true 
	#Es soll nicht gegen den eigenen Körper stoßen
	heldItem.add_collision_exception_with(player)
	
func throw_held() -> void:
	heldItem.freeze = false
	#Kollision wieder normal
	heldItem.remove_collision_exception_with(player)
	#In Blickrichtung loslassen
	heldItem.linear_velocity = -global_basis.z * throw_speed
	heldItem=null
	
	
