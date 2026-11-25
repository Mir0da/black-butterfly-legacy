extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.is_event_completed("event_3"):
		$MarginContainer/MainContainer/StoryLine/Event2.text = "Rekonstruiert!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_event_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/szene_1.tscn")
