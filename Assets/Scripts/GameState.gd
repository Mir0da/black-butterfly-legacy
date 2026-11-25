extends Node

var completed_events: Dictionary = {}

func complete_event(event_id: String) -> void:
	completed_events[event_id] = true

func is_event_completed(event_id: String) -> bool:
	return completed_events.get(event_id, false)
