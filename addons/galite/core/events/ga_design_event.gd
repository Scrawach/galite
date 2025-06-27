class_name GADesignEvent
extends GAEvent

var event_id: String
var value

func _init(event_id: String) -> void:
	self.event_id = event_id

func serialize(properties: GALiteProperties) -> Dictionary:
	var required_data := {
		CATEGORY: "design",
		"event_id": event_id
	}
	
	if value:
		required_data["value"] = value
	
	return required_data

func with_value(value: float) -> GADesignEvent:
	self.value = value
	return self
