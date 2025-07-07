class_name GAAdEvent
extends GAEvent

enum Type {
	VIDEO = 0,
	REWARDED_VIDEO = 1,
	PLAYABLE = 2,
	INTERSTITIAL = 3,
	OFFER_WALL = 4,
	BANNER = 5
}

enum Action {
	CLICKED = 0,
	SHOW = 1,
	FAILED_SHOW = 2,
	REWARD_RECEIVED = 3
}

enum FailReason {
	UNKNOWN = 0,
	OFFLINE = 1,
	NO_FILL = 2,
	INTERNAL_ERROR = 3,
	INVALID_REQUEST = 4,
	UNABLE_TO_PRECACHE = 5
}

var ad_sdk_name: String
var ad_placement: String
var ad_type: Type
var ad_action: Action

var ad_fail_show_reason
var ad_duration
var ad_first: bool

func _init(sdk_name: String, placement: String, type: Type, action: Action) -> void:
	super._init()
	self.ad_sdk_name = sdk_name
	self.ad_placement = placement
	self.ad_type = type
	self.ad_action = action

func serialize(properties: GALiteProperties) -> Dictionary:
	var required_data = { 
		CATEGORY: "ads",
		"ad_sdk_name": ad_sdk_name,
		"ad_placement": ad_placement,
		"ad_type": get_string_from_enum(ad_type, Type),
		"ad_action": get_string_from_enum(ad_action, Action)
	}
	
	if ad_fail_show_reason:
		required_data["ad_fail_show_reason"] = get_string_from_enum(ad_fail_show_reason, FailReason)
	
	if ad_duration:
		required_data["ad_duration"] = ad_duration
	
	if ad_first:
		required_data["ad_first"] = true
	
	return required_data

func failed_by(reason: FailReason) -> GAAdEvent:
	ad_fail_show_reason = reason
	return self

func with_duration(duration_in_ms: int) -> GAAdEvent:
	ad_duration = duration_in_ms
	return self

func mark_as_first() -> GAAdEvent:
	ad_first = true
	return self

static func get_string_from_enum(value: int, target) -> String:
	for key in target.keys():
		if target[key] == value:
			return key.to_lower()
	return "none"
