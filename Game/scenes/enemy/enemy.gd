extends CharacterBody2D

const SHOOT_FRAME = 8

@export var speed := 40
@export var accel := 400
@export var hp := 100:
	set(v):
		hp = v
		if not is_node_ready():
			await ready
		_hp_bar.value = hp

@export var hurt_impluse := 200.0

@onready var _sprite := %Sprite as AnimatedSprite2D
@onready var _shoot_pos := %ShootPos as Marker2D
@onready var _hp_bar := %HpBar as ProgressBar
@onready var _detect_range := %DetectRange as Area2D
@onready var _shoot_timer := %ShootTimer as Timer

var _shoot_pos_ofs_h: float
var _ori_pos: Vector2

var _target: Node2D


func _ready() -> void:
	_shoot_timer.timeout.connect(_on_timer_timeout)
	_sprite.animation_finished.connect(_on_animation_finished)
	_sprite.frame_changed.connect(_on_frame_changed)

	_detect_range.body_entered.connect(_on_detect_body_entered)
	_detect_range.body_exited.connect(_on_detect_body_exited)

	_sprite.play(&"idle")
	_shoot_pos_ofs_h = _shoot_pos.position.x
	_hp_bar.value = hp
	_hp_bar.max_value = hp

	_ori_pos = global_position


func _process(delta: float) -> void:
	var target_velocity := Vector2.ZERO
	if not _is_attacking() and not _is_hurting():
		if is_instance_valid(_target):
			target_velocity = global_position.direction_to(_target.global_position) * speed
		else:
			target_velocity = global_position.direction_to(_ori_pos) * speed

	velocity = velocity.move_toward(target_velocity, accel * delta)

	if not is_instance_valid(_target) and (global_position + velocity * delta).distance_to(_ori_pos) > global_position.distance_to(_ori_pos):
		velocity = (_ori_pos - global_position) / speed

	move_and_slide()

	if not is_instance_valid(_target) and global_position.is_equal_approx(_ori_pos):
		velocity = Vector2.ZERO

	if not _is_attacking() and not _is_hurting():
		if not is_zero_approx(velocity.x):
			_sprite.flip_h = velocity.x > 0.0

		const idle_speed := 20.0
		if velocity.length() < idle_speed and not _sprite.animation == &"idle":
			_sprite.play(&"idle")
		elif velocity.length() >= idle_speed and not _sprite.animation == &"run":
			_sprite.play(&"run")
	elif _is_attacking():
		_sprite.flip_h = (_target.global_position - global_position).x > 0

	#
	_shoot_pos.position.x = _shoot_pos_ofs_h * (-1 if _sprite.flip_h else 1)


# ----------
func take_damage(damge: int, dir: Vector2) -> void:
	hp -= damge
	velocity = dir * hurt_impluse
	_sprite.play("hurt")


# -------------
func _is_attacking() -> bool:
	return _sprite.animation == &"attack"


func _is_hurting() -> bool:
	return _sprite.animation == &"hurt"


func _on_frame_changed() -> void:
	if not _is_attacking():
		return

	if hp <= 0 and not _sprite.animation == &"hurt":
		_sprite.play(&"hurt")
		return

	if _sprite.frame == SHOOT_FRAME and is_instance_valid(_target):
		_shoot_pos.look_at(_target.global_position + Vector2.UP * 8)
		var bullet = preload("bullet.tscn").instantiate()
		bullet.global_transform = _shoot_pos.global_transform
		get_tree().root.add_child(bullet)


func _on_animation_finished() -> void:
	if _sprite.animation in [&"attack", &"hurt"]:
		_sprite.play(&"idle")
	if hp <= 0:
		queue_free()


func _on_detect_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		_target = body


func _on_detect_body_exited(body: PhysicsBody2D) -> void:
	if not body.is_in_group("player"):
		return
	if _target != body:
		return

	if _is_attacking():
		await _sprite.animation_changed
		if not _target in _detect_range.get_overlapping_bodies():
			return
	_target = null


func _on_timer_timeout() -> void:
	if is_instance_valid(_target) and not _is_attacking():
		_sprite.play(&"attack")
