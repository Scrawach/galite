class_name GAHTTPResponse
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
	return "%s, %s, %s, %s" % [code, status_code, headers, body]
