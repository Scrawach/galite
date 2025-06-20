extends Node

func _ready() -> void:
	#Setup GALite with url, game and secret keys
	#GALite.base_url = "https://api.gameanalytics.com/v2/"
	#GALite.game_key = "[GAME_KEY]"
	#GALite.secret_key = "[SECRET_KEY]"
	
	await GALite.request_init()
	await GALite.request(GAUserEvent.session_start())
	await GALite.request(GAProgressionEvent.start("World03"))
	await GALite.request(GAProgressionEvent.fail("World03").with_attempt_number(5))
	await GALite.request(GAProgressionEvent.complete("World03").with_score(42))
	await GALite.request(GAUserEvent.session_end(5))
