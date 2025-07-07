class_name GAEvent
extends RefCounted

const CATEGORY: String = "category"

var timestamp: int

func _init() -> void:
	self.timestamp = Time.get_unix_time_from_system()

func serialize(properties: GALiteProperties) -> Dictionary:
	return { }
