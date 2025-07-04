class_name GALiteHTTPResponse
extends RefCounted

var code: int
var status_code: int
var headers: PackedStringArray
var body

func _init(code: int, status_code: int, headers: PackedStringArray, body = null) -> void:
	self.code = code
	self.status_code = status_code
	self.headers = headers
	self.body = body

func _to_string() -> String:
	return "Operation Code: %s, Status: %s, Headers: %s, Body: %s" % [code, status_code, headers, body]

static func from_array(content: Array) -> GALiteHTTPResponse:
	return GALiteHTTPResponse.new(content[0], content[1], content[2], content[3].get_string_from_ascii())
