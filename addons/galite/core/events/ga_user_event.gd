class_name GAUserEvent
extends GAEvent

var elapsed_seconds

func serialize(properties: GALiteProperties) -> Dictionary:
	if elapsed_seconds:
		return {
			"category": "session_end",
			"length": elapsed_seconds
		}
	
	return {
		"category": "user"
	}

static func session_start() -> GAUserEvent:
	return GAUserEvent.new()

static func session_end(elapsed_seconds: int) -> GAUserEvent:
	var event = GAUserEvent.new()
	event.elapsed_seconds = elapsed_seconds
	return event
