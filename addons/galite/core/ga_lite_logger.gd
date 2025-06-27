class_name GALiteLogger
extends RefCounted

enum LogLevel {
	NONE = 0,
	ERROR = 10,
	WARNING = 20,
	INFO = 30,
	VERBOSE = 40,
	DEBUG = 50
}

var _level := LogLevel.ERROR
var _name := "Base GALite Logger"

func _init(name: String, level: LogLevel = LogLevel.DEBUG) -> void:
	self._name = name
	self._level = level

func set_log_level(new_level: LogLevel) -> void:
	self._level = new_level

func debug(message) -> void:
	_log(LogLevel.DEBUG, message)

func verbose(message) -> void:
	_log(LogLevel.VERBOSE, message)

func info(message) -> void:
	_log(LogLevel.INFO, message)

func warning(message) -> void:
	_log(LogLevel.WARNING, message)

func error(message) -> void:
	_log(LogLevel.ERROR, message)

func _log(level: int, message) -> void:
	if level > _level:
		return
	
	print(_get_converted_message(level, message))

func _get_converted_message(level: int, message) -> String:
	return "%s [%s] %s: %s" % [_get_datetime(), _get_level_string(level), _name, str(message)]

func _get_level_string(level: int) -> String:
	var index: int = LogLevel.values().find(level)
	return LogLevel.keys()[index] if index > -1 else "UNKNOWN"

func _get_datetime() -> String:
	var time = Time.get_datetime_dict_from_system()
	var msec = Time.get_ticks_msec() % 1000
	return "%02d-%02d-%02dT%02d:%02d:%02d.%03d" % [time.year, time.month, time.day, time.hour, time.minute, time.second, msec]
