extends Node

func _ready() -> void:
	var properties := GAProperties.make_default("[GAME_KEY]", "[SECRET_KEY]")
	GALite.initialize(properties)
	await GALite.request_init()
	await GALite.request(GAUserEvent.session_start())
	await GALite.request(GAProgressionEvent.start("World05"))
	await GALite.request(GAProgressionEvent.fail("World05").with_score(42))
	await GALite.request(GAProgressionEvent.complete("World05").with_attempt_number(3))
	await GALite.request(GAUserEvent.session_end(5))
