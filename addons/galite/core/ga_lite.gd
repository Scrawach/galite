extends Node

# This default sandbox setups
# Can be used for test connection
var base_url: String = "https://sandbox-api.gameanalytics.com/v2/"
var game_key: String = "5c6bcb5402204249437fb5a7a80a4959"
var secret_key: String = "16813a12f718bc5c620f56944e1abc3ea13ccbac"

enum GAProgression {
	Start = 0,
	Complete = 1,
	Fail = 2
}

var shared_annotations: Dictionary

func _ready() -> void:
	var version = Engine.get_version_info()
	var engine_version: String = "godot %s.%s.%s" % [version.major, version.minor, version.patch]
	
	shared_annotations = {
		"device": OS.get_model_name(),
		"v": 2,
		"user_id": "test_id",
		"client_ts": 0,
		"sdk_version": "rest api v2",
		"os_version": "webgl 2.0",
		"manufacturer": "-",
		"platform": "webgl",
		"session_id": "de305d54-75b4-431b-adb2-eb6b9e546014",
		"session_num": 1,
		"engine_version": engine_version
	}

func request_init() -> int:
	var init_payload: Dictionary = {
		platform = "ios",
		os_version = "ios 8.1",
		sdk_version = "rest api v2"
	}
	var init_payload_json: String = JSON.stringify(init_payload)
	return await _request(_make_url("init"), init_payload_json)

func request(event: GAEvent) -> int:
	var serialized: Dictionary = event.serialize()
	serialized.merge(shared_annotations.duplicate())
	var json: String = JSON.stringify([serialized])
	return await _request(_make_url("events"), json)

func _make_url(endpoint: String) -> String:
	return base_url + game_key + "/" + endpoint

func _request(endpoint: String, content: String) -> int:
	var hmac_hash: String = hmac_auth_hash(content, secret_key)
	var headers: PackedStringArray = ["Content-Encoding: application/json", "Authorization: %s" % hmac_hash]
	var request = HTTPRequest.new()
	add_child(request)
	var error: int = request.request(endpoint, headers, HTTPClient.METHOD_POST, content)
	var response = await request.request_completed
	_debug("Received: %s, %s, %s, %s" % [response[0], response[1], response[2], response[3].get_string_from_ascii()])
	request.queue_free()
	return response[1]

func hmac_auth_hash(body: String, secret: String) -> String:
	var hmac := HMACContext.new()
	hmac.start(HashingContext.HASH_SHA256, secret.to_utf8_buffer())
	hmac.update(body.to_utf8_buffer())
	return Marshalls.raw_to_base64(hmac.finish())

func _debug(content: String) -> void:
	print(content)
