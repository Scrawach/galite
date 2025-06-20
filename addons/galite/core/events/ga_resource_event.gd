class_name GAResourceEvent
extends GAEvent

var event_id: String
var amount: float

func _init(event_id: String, amount: float) -> void:
	self.event_id = event_id
	self.amount = amount

func serialize() -> Dictionary:
	return {
		CATEGORY: "resource",
		"event_id": event_id,
		"amount": amount
	}

static func sink(currency: String, item_type: String, item_id: String, amount: float) -> GAResourceEvent:
	var event_id: String = "Sink:%s:%s:%s" % [currency, item_type, item_id]
	return GAResourceEvent.new(event_id, amount)

static func source(currency: String, item_type: String, item_id: String, amount: float) -> GAResourceEvent:
	var event_id: String = "Source:%s:%s:%s" % [currency, item_type, item_id]
	return GAResourceEvent.new(event_id, amount)
