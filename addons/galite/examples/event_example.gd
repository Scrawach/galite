extends Node

func _ready() -> void:
	#Setup GALite with url, game and secret keys
	#GALite.base_url = "https://api.gameanalytics.com/v2/"
	#GALite.game_key = "[GAME_KEY]"
	#GALite.secret_key = "[SECRET KEY]"
	
	await GALite.request_init()
	await GALite.progression_request(GALite.GAProgression.Start, "World01")
	await GALite.progression_request(GALite.GAProgression.Complete, "World01")
	await GALite.progression_request(GALite.GAProgression.Fail, "World01")
