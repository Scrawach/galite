class_name GAErrorEvent
extends GAEvent

const DEBUG := "debug"
const INFO := "info"
const WARNING := "warning"
const ERROR := "error"
const CRITICAL := "critical"

var severity: String
var message: String

func _init(severity: String, message: String) -> void:
	self.severity = severity
	self.message = message

func serialize(properties: GALiteProperties) -> Dictionary:
	return {
		CATEGORY: "error",
		"severity": severity,
		"message": message
	}

static func debug(message: String) -> GAErrorEvent:
	return GAErrorEvent.new(DEBUG, message)

static func info(message: String) -> GAErrorEvent:
	return GAErrorEvent.new(INFO, message)

static func warning(message: String) -> GAErrorEvent:
	return GAErrorEvent.new(WARNING, message)

static func error(message: String) -> GAErrorEvent:
	return GAErrorEvent.new(ERROR, message)

static func critical(message: String) -> GAErrorEvent:
	return GAErrorEvent.new(CRITICAL, message)
