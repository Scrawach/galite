class_name GALiteProperties
extends RefCounted

# Sandbox Keys
var base_url: String = "https://api.gameanalytics.com/v2/"
var game_key: String = "5c6bcb5402204249437fb5a7a80a4959"
var secret_key: String = "16813a12f718bc5c620f56944e1abc3ea13ccbac"

# Required fields:
var device: String = OS.get_model_name().to_lower()
var v: int = 2
var user_id: String = "unknown" # should be generated and stored in local db
var client_ts: int = 0
var sdk_version: String = "rest api v2"
var os_version: String = OS.get_name().to_lower() + " " # whitespace required in GA
var manufacturer: String = OS.get_name().to_lower()
var platform: String = OS.get_name().to_lower()
var session_id: String = "de305d54-75b4-431b-adb2-eb6b9e546014" # should be generated
var session_num: int = 1 # should be incremented and stored in local db

# Not required fields:
var limit_ad_tracking # bool
var android_id: String
var custom_01: String
var custom_02: String
var custom_03: String
var build: String
var engine_version: String
var connection_type: String

# Required for IOS
var ios_idfv: String
var ios_idfa: String

# Required for Android
var google_aid: String

# Required for events
var business_transaction_num: int = 1 # used for business event

func serialize() -> Dictionary:
	var required_data := {
		"device": device,
		"v": v,
		"user_id": user_id,
		"client_ts": client_ts,
		"sdk_version": sdk_version,
		"os_version": os_version,
		"manufacturer": manufacturer,
		"platform": platform,
		"session_id": session_id,
		"session_num": session_num,
	}
	
	if limit_ad_tracking != null:
		required_data["limit_ad_tracking"] = limit_ad_tracking
	
	_setup_if_exist(required_data, "android_id", android_id)
	_setup_if_exist(required_data, "custom_01", custom_01)
	_setup_if_exist(required_data, "custom_02", custom_02)
	_setup_if_exist(required_data, "custom_03", custom_03)
	_setup_if_exist(required_data, "build", build)
	_setup_if_exist(required_data, "engine_version", engine_version)
	_setup_if_exist(required_data, "ios_idfv", ios_idfv)
	_setup_if_exist(required_data, "ios_idfa", ios_idfa)
	_setup_if_exist(required_data, "google_aid", google_aid)
	
	return required_data

func _setup_if_exist(target: Dictionary, key: String, value: String) -> void:
	if not value.is_empty():
		target[key] = value

func get_engine_version() -> String:
	var version = Engine.get_version_info()
	return "godot %s.%s.%s" % [version.major, version.minor, version.patch]

static func make_sandbox() -> GALiteProperties:
	var properties := GALiteProperties.new()
	properties.base_url = "https://sandbox-api.gameanalytics.com/v2/"
	properties.game_key = "5c6bcb5402204249437fb5a7a80a4959"
	properties.secret_key = "16813a12f718bc5c620f56944e1abc3ea13ccbac"
	return GALiteProperties.new()

static func make_default(game_key: String, secret_key: String) -> GALiteProperties:
	var properties := GALiteProperties.new()
	properties.base_url = "https://api.gameanalytics.com/v2/"
	properties.game_key = game_key
	properties.secret_key = secret_key
	return properties
	
