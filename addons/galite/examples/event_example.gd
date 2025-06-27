extends Node

func _ready() -> void:
	var properties := GALiteProperties.make_default("[GAME_KEY]", "[SECRET_KEY]")
	properties.make_sandbox()
	properties.user_id = "test-user-0"  	# Generate unique user id or load from saves, 
											# it's should be stored in local db
	properties.session_id = "session-0" 	# Generate unique session id
	properties.session_num = 1				# it's should be stored in local db
	properties.business_transaction_num = 1	# it's should be stored in local db
	
	GALite.initialize(properties)
	
	await GALite.request_init_async()
	await GALite.request_async(GAUserEvent.session_start())
	await GALite.request_async(GAProgressionEvent.start("World05"))
	await GALite.request_async(GAProgressionEvent.fail("World05").with_score(42))
	await GALite.request_async(GAProgressionEvent.complete("World05").with_attempt_number(3))
	await GALite.request_async(GAUserEvent.session_end(5))
