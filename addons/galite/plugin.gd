@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("GALite", "res://addons/galite/core/ga_lite.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton("GALite")
