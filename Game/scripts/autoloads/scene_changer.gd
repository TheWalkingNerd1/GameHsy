extends CanvasLayer

var _panel := Panel.new()


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	add_child(_panel)
	_panel.anchors_preset = Control.PRESET_FULL_RECT
	_panel.self_modulate = Color.BLACK
	_panel.self_modulate.a = 0.0
	hide()


func change_scene_to_packed_async(packed_scene: PackedScene) -> void:
	assert(is_instance_valid(packed_scene))
	var prev_paused := get_tree().paused
	get_tree().paused = true
	show()
	var tween := create_tween()
	tween.tween_property(_panel, ^"self_modulate:a", 1.0, 0.2)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(packed_scene))
	tween.tween_property(_panel, ^"self_modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): get_tree().paused = prev_paused ; hide())


func change_scene_to_file_async(scene_file: String) -> void:
	change_scene_to_packed_async(load(scene_file))
