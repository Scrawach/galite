extends Node

func _ready() -> void:
	var properties := GALiteProperties.make_sandbox()
	GALite.initialize(properties)
	
	await GALite.request_init_async()
	await GALite.request_group_async([
		GAUserEvent.session_start(),
		GAProgressionEvent.complete("World1"),
		GADesignEvent.new("Gameplay:kill:orc"),
		GADesignEvent.new("Gameplay:kill:goblin"),
		GAUserEvent.session_end(1)
	])
