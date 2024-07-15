extends CharacterBody2D

static var hp := 100

@export var speed := 100.0
@export var accel := 500.0
@export var attak_damge := 50 as int

@export var map: TileMap:
	set(v):
		map = v
		if not is_node_ready():
			await ready
		update_camera_limit(map)

@onready var _sprite := %Sprite as AnimatedSprite2D
@onready var _hitbox := %HitBox as Area2D
@onready var _camera := %Camera2D as Camera2D
@onready var _hp_bar := %HpBar as ProgressBar


func _ready() -> void:
	_sprite.frame_changed.connect(_on_sprite_frame_changed)
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_hitbox.body_entered.connect(_on_hitbox_body_entered)
	_sprite.play(&"idle")
	_hp_bar.value = hp


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_attack()
		get_tree().root.set_input_as_handled()


func _process(delta: float) -> void:
	var target_velocity := Vector2.ZERO
	if not _is_attacking() and not _is_hurting():
		var dir := Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
		target_velocity = dir * speed

	velocity = velocity.move_toward(target_velocity, accel * delta)
	move_and_slide()

	if not _is_attacking() and not _is_hurting():
		const idle_speed := 20
		if velocity.length() < idle_speed and _sprite.animation != &"idle":
			_sprite.play(&"idle")
		elif velocity.length() >= idle_speed and _sprite.animation != &"run":
			_sprite.play(&"run")

	if _is_hurting():
		return

	if is_zero_approx(target_velocity.x):
		return
	if not is_zero_approx(target_velocity.x):
		_sprite.flip_h = target_velocity.x < 0
	_hitbox.rotation = PI if _sprite.flip_h else 0.0


# ---------------
func take_damage(damage: int, dir: Vector2) -> void:
	hp -= damage
	velocity = dir * speed
	_sprite.play(&"hurt")
	_hp_bar.value = hp


func update_camera_limit(tile_map: TileMap) -> void:
	var map_rect := tile_map.get_used_rect()
	var tile_size := tile_map.rendering_quadrant_size
	var map_size := map_rect.size * tile_size
	var map_pos := map_rect.position* tile_size
	if map_size < Vector2i(get_tree().root.size / get_tree().root.content_scale_factor):
		# 场景小于相机
		return
	_camera.limit_left = map_pos.x
	_camera.limit_top = map_pos.y
	_camera.limit_right = map_size.x + map_pos.x
	_camera.limit_bottom = map_size.y + map_pos.y


# ----------
func _set_hit_box_enabled(enabled: bool) -> void:
	_hitbox.monitoring = enabled


func _is_attacking() -> bool:
	return _sprite.animation == &"attack"


func _is_hurting() -> bool:
	return _sprite.animation == &"hurt"


func _attack() -> void:
	if _is_attacking():
		return
	_sprite.play(&"attack")


func _on_sprite_frame_changed() -> void:
	const HIT_FRAME_RANGE = [6, 9]
	var in_hit_range := _sprite.frame >= HIT_FRAME_RANGE[0] and _sprite.frame <= HIT_FRAME_RANGE[1]
	_set_hit_box_enabled(_is_attacking() and in_hit_range)


func _on_sprite_animation_finished() -> void:
	if _sprite.animation in [&"attack", &"hurt"]:
		_sprite.play(&"idle")
	if hp <= 0:
		var pos := _camera.global_position
		remove_child(_camera)
		_camera.global_position = pos
		get_parent().add_child(_camera)

		queue_free()


func _on_hitbox_body_entered(body: PhysicsBody2D) -> void:
	if not body.is_in_group("enemy"):
		return
	if body.has_method(&"take_damage"):
		body.take_damage(attak_damge, global_position.direction_to(body.global_position))
