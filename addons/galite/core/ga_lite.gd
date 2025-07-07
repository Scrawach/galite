extends Node

signal initialized(properties: GALiteProperties)
signal request_completed(response: GALiteHTTPResponse)

var logger := GALiteLogger.new("GALite")
var properties: GALiteProperties

var url_init: String
var url_events: String

var timestamp_offset: int

func initialize(properties: GALiteProperties) -> void:
	self.properties = properties
	self.url_init = _make_url("init")
	self.url_events = _make_url("events")
	self.initialized.emit(properties)

func request_init_async() -> GALiteHTTPResponse:
	const SERVER_TIMESTAMP: String = "server_ts"
	
	var response := await _request_async(url_init, _make_init_request())
	
	if response.is_ok() and response.body and response.body.has(SERVER_TIMESTAMP):
		timestamp_offset = get_current_time() - response.body[SERVER_TIMESTAMP]
	
	return response

func request_async(event: GAEvent) -> GALiteHTTPResponse:
	return await _request_async(url_events, _serialize_event(event))

func request_group_async(events: Array[GAEvent]) -> GALiteHTTPResponse:
	return await _request_async(url_events, _serialize_group_of_events(events))

func _make_init_request() -> String:
	return JSON.stringify({
		platform = properties.platform,
		os_version = properties.os_version,
		sdk_version = properties.sdk_version
	})

func _serialize_event(event: GAEvent) -> String:
	return JSON.stringify([_pack_event_with_properties(event)])

func _serialize_group_of_events(events: Array[GAEvent]) -> String:
	var group_request: Array
	for event in events:
		group_request.append(_pack_event_with_properties(event))
	return JSON.stringify(group_request)

func _pack_event_with_properties(event: GAEvent) -> Dictionary:
	var serialized_event: Dictionary = event.serialize(properties)
	serialized_event.merge(properties.serialize())
	serialized_event["client_ts"] = event.timestamp - timestamp_offset
	return serialized_event

func _make_url(endpoint: String) -> String:
	return properties.base_url + properties.game_key + "/" + endpoint

func _request_async(endpoint: String, content: String) -> GALiteHTTPResponse:
	var request = HTTPRequest.new()
	add_child(request)
	
	if logger.can_log(GALiteLogger.LogLevel.DEBUG):
		logger.debug("REQUEST \"%s\": %s" % [endpoint, content])
	
	var error: int = request.request(endpoint, _make_headers(content), HTTPClient.METHOD_POST, content)
	var response = await request.request_completed as Array
	var ga_response := GALiteHTTPResponse.from_array(response)
	
	if logger.can_log(GALiteLogger.LogLevel.DEBUG):
		logger.debug("RECEIVED: %s" % ga_response)
	
	request_completed.emit(ga_response)
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

func get_current_time() -> int:
	return Time.get_unix_time_from_system()
