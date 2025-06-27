extends Node

func _ready() -> void:
	var properties := GALiteProperties.make_default("[GAME_KEY]", "[SECRET_KEY]")
	properties.user_id = "test-user-0"  	# Generate unique user id or load from saves, 
											# it's should be stored in local db
	properties.session_id = "session-0" 	# Generate unique session id
	properties.session_num = 1				# it's should be stored in local db
	properties.business_transaction_num = 1	# it's should be stored in local db
	
	GALite.initialize(properties)
	
	await GALite.request_init_async()
	await GALite.request_async(GAUserEvent.session_start())
	
	# business events:
	await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem0", 50, "USD"))
	await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem0", 10, "USD").purchased_from("event_example"))
	await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem1", 50, "USD").with_receipt("google", "[RECEIPT]", "[SIGNATURE]"))
	
	# resource events:
	await GALite.request_async(GAResourceEvent.sink("gold", "boost", "rainbowBoost", 10))
	await GALite.request_async(GAResourceEvent.source("gold", "mine", "mineBoost", 15))
	
	# progression events:
	await GALite.request_async(GAProgressionEvent.start("World05"))
	await GALite.request_async(GAProgressionEvent.fail("World05").with_score(42))
	await GALite.request_async(GAProgressionEvent.complete("World05").with_attempt_number(3))
	
	# design events:
	await GALite.request_async(GADesignEvent.new("GamePlay:kill:goblin"))
	await GALite.request_async(GADesignEvent.new("GamePlay:heal:goblin"))
	await GALite.request_async(GADesignEvent.new("GamePlay:kill:orc"))
	
	# error events:
	await GALite.request_async(GAErrorEvent.debug("test debug message"))
	await GALite.request_async(GAErrorEvent.info("test info message"))
	await GALite.request_async(GAErrorEvent.warning("test warning message"))
	await GALite.request_async(GAErrorEvent.error("test error message"))
	await GALite.request_async(GAErrorEvent.critical("test critical message"))
	
	await GALite.request_async(GAUserEvent.session_end(5))
	
	# save user_id, session_num and business_transaction_num in local db
