extends Control



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	Loader.change_level("res://Scene/Menu/Main_menu.tscn")
