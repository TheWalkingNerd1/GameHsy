extends Area2D

@export var speed := 200.0
@export var shoot_range := 250
@export var damage := 10

var _start_position: Vector2
var _range_squared: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_range_squared = pow(shoot_range, 2.0)
	(func(): _start_position = global_position).call_deferred()


func _process(delta: float) -> void:
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
	if _start_position.distance_squared_to(global_position) > _range_squared:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method(&"take_damage"):
		body.take_damage(damage, Vector2.RIGHT.rotated(rotation))
	queue_free()
