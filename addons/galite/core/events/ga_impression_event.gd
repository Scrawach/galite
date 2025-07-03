class_name GAImpressionEvent
extends GAEvent

var ad_network_name: String
var impression_data: Dictionary

func _init(network_name: String, data: Dictionary) -> void:
	self.ad_network_name = network_name
	self.impression_data = data

func serialize(properties: GALiteProperties) -> Dictionary:
	return {
		CATEGORY: "impression",
		"ad_network_name": ad_network_name,
		"impression_data": impression_data
	}
