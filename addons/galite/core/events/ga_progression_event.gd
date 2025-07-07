class_name GAProgressionEvent
extends GAEvent

const START: String = "Start"
const COMPLETE: String = "Complete"
const FAIL: String = "Fail"

var status: String
var progression: String
var score
var attempt_number

func _init(status: String, progression: String) -> void:
	super._init()
	self.status = status
	self.progression = progression

func with_score(score: int) -> GAProgressionEvent:
	self.score = score
	return self

func with_attempt_number(attempts: int) -> GAProgressionEvent:
	self.attempt_number = attempts
	return self

func serialize(properties: GALiteProperties) -> Dictionary:
	var event := {
		"category": "progression",
		"event_id": "%s:%s" % [status, progression]
	}
	
	if score:
		event["score"] = score
	
	if attempt_number:
		event["attempt_num"] = attempt_number
	
	return event

static func start(name: String) -> GAProgressionEvent:
	return GAProgressionEvent.new(START, name)

static func fail(name: String) -> GAProgressionEvent:
	return GAProgressionEvent.new(FAIL, name)

static func complete(name: String) -> GAProgressionEvent:
	return GAProgressionEvent.new(COMPLETE, name)
