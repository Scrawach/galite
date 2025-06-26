extends Node

func _ready() -> void:
	var properties := GAProperties.make_default("[GAME_KEY]", "[SECRET_KEY]")
	GALite.initialize(properties)
	await GALite.request_init_async()
	await GALite.request_async(GAUserEvent.session_start())
	await GALite.request_async(GAProgressionEvent.start("World05"))
	await GALite.request_async(GAProgressionEvent.fail("World05").with_score(42))
	await GALite.request_async(GAProgressionEvent.complete("World05").with_attempt_number(3))
	await GALite.request_async(GAUserEvent.session_end(5))
