extends Area2D

@export var target_scene:String

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		assert(not target_scene.is_empty())
		SceneChanger.change_scene_to_file_async(target_scene)
