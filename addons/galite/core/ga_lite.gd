extends Node

var properties: GAProperties

var url_init: String
var url_events: String

func initialize(properties: GAProperties) -> void:
	self.properties = properties
	self.url_init = _make_url("init")
	self.url_events = _make_url("events")

func request_init() -> int:
	var init_payload: Dictionary = {
		platform = properties.platform,
		os_version = properties.os_version,
		sdk_version = properties.sdk_version
	}
	var init_payload_json: String = JSON.stringify(init_payload)
	var response = await _request(url_init, init_payload_json)
	return response[0]

func request(event: GAEvent) -> int:
	var serialized: Dictionary = event.serialize()
	serialized.merge(properties.serialize())
	var json: String = JSON.stringify([serialized])
	var response = await _request(url_events, json)
	return response[0]

func _make_url(endpoint: String) -> String:
	return properties.base_url + properties.game_key + "/" + endpoint

func _request(endpoint: String, content: String) -> Array:
	var request = HTTPRequest.new()
	add_child(request)
	var error: int = request.request(endpoint, _make_headers(content), HTTPClient.METHOD_POST, content)
	var response = await request.request_completed
	_debug("Received: %s, %s, %s, %s" % [response[0], response[1], response[2], response[3].get_string_from_ascii()])
	request.queue_free()
	return response

func _make_headers(content: String) -> PackedStringArray:
	var hmac_hash: String = hmac_auth_hash(content, properties.secret_key)
	return ["Content-Encoding: application/json", "Authorization: %s" % hmac_hash]

func hmac_auth_hash(body: String, secret: String) -> String:
	var hmac := HMACContext.new()
	hmac.start(HashingContext.HASH_SHA256, secret.to_utf8_buffer())
	hmac.update(body.to_utf8_buffer())
	return Marshalls.raw_to_base64(hmac.finish())

func _debug(content: String) -> void:
	print(content)
