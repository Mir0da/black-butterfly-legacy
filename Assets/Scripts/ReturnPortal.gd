extends Area3D

@export var target_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and target_scene != null:
		
		#TEST
		GameState.complete_event("event_3")
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().call_deferred(
			"change_scene_to_packed",
			target_scene
		)
