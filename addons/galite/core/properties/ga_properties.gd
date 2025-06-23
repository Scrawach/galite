class_name GAProperties
extends RefCounted

# Sandbox Keys
var base_url: String = "https://sandbox-api.gameanalytics.com/v2/"
var game_key: String = "5c6bcb5402204249437fb5a7a80a4959"
var secret_key: String = "16813a12f718bc5c620f56944e1abc3ea13ccbac"

# Required fields:
var device: String = OS.get_model_name().to_lower()
var v: int = 2
var user_id: String = "unknown"
var client_ts: int = 0
var sdk_version: String = "rest api v2"
var os_version: String = OS.get_name().to_lower() + " " # whitespace required
var manufacturer: String = OS.get_name().to_lower()
var platform: String = OS.get_name().to_lower()
var session_id: String = "de305d54-75b4-431b-adb2-eb6b9e546014"
var session_num: int = 1

# Not required fields:
var limit_ad_tracking: bool
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

func serialize() -> Dictionary:
	return {
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

func get_engine_version() -> String:
	var version = Engine.get_version_info()
	return "godot %s.%s.%s" % [version.major, version.minor, version.patch]

static func make_sandbox() -> GAProperties:
	return GAProperties.new()

static func make_default(game_key: String, secret_key: String) -> GAProperties:
	var properties := GAProperties.new()
	properties.base_url = "https://api.gameanalytics.com/v2/"
	properties.game_key = game_key
	properties.secret_key = secret_key
	return properties
	
