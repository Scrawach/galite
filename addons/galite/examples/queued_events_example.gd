extends Node

var queued_events: Array[GAEvent]

func add_event(event: GAEvent) -> void:
	queued_events.append(event)

func submit_all_events() -> void:
	var response := await GALite.request_group_async(queued_events)
	queued_events.clear()
