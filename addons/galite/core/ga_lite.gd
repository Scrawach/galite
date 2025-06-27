extends Node

var logger := GALiteLogger.new("GALite")
var properties: GALiteProperties

var url_init: String
var url_events: String

func initialize(properties: GALiteProperties) -> void:
	self.properties = properties
	self.url_init = _make_url("init")
	self.url_events = _make_url("events")

func request_init_async() -> GALiteHTTPResponse:
	return await _request_async(url_init, _make_init_request())

func request_async(event: GAEvent) -> GALiteHTTPResponse:
	properties.client_ts = int(Time.get_unix_time_from_system())
	return await _request_async(url_events, _serialize_event(event))

func request_group_async(events: Array) -> GALiteHTTPResponse:
	properties.client_ts = int(Time.get_unix_time_from_system())
	return await _request_async(url_events, _serialize_group_of_events(events))

func _make_init_request() -> String:
	return JSON.stringify({
		platform = properties.platform,
		os_version = properties.os_version,
		sdk_version = properties.sdk_version
	})

func _serialize_event(event: GAEvent) -> String:
	var serialized_event: Dictionary = event.serialize(properties)
	serialized_event.merge(properties.serialize())
	return JSON.stringify([serialized_event])

func _serialize_group_of_events(events: Array) -> String:
	var group_request: Array
	var serialized_properties: Dictionary = properties.serialize()
	for event in events:
		var ga_event: GAEvent = event as GAEvent
		var serialized_event: Dictionary = ga_event.serialize(properties)
		serialized_event.merge(serialized_properties)
		group_request.append(serialized_event)
	return JSON.stringify(group_request)

func _make_url(endpoint: String) -> String:
	return properties.base_url + properties.game_key + "/" + endpoint

func _request_async(endpoint: String, content: String) -> GALiteHTTPResponse:
	var request = HTTPRequest.new()
	add_child(request)
	
	var error: int = request.request(endpoint, _make_headers(content), HTTPClient.METHOD_POST, content)
	var response = await request.request_completed
	var ga_response := GALiteHTTPResponse.new(response[0], response[1], response[2], response[3].get_string_from_ascii())
	
	logger.debug("Received: %s" % ga_response)
	request.queue_free()
	return ga_response

func _make_headers(content: String) -> PackedStringArray:
	var hmac_hash: String = hmac_auth_hash(content, properties.secret_key)
	return ["Content-Encoding: application/json", "Authorization: %s" % hmac_hash]

func hmac_auth_hash(body: String, secret: String) -> String:
	var hmac := HMACContext.new()
	hmac.start(HashingContext.HASH_SHA256, secret.to_utf8_buffer())
	hmac.update(body.to_utf8_buffer())
	return Marshalls.raw_to_base64(hmac.finish())
