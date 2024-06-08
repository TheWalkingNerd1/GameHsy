#ifndef CHARACTER_H
#define CHARACTER_H

#include <godot_cpp/classes/character_body2d.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/collision_shape2d.hpp>
#include <godot_cpp/classes/rectangle_shape2d.hpp>
#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/classes/resource_loader.hpp>

namespace godot {

class Character : public CharacterBody2D {
	GDCLASS(Character, CharacterBody2D)

private:
    float speed;
    Vector2 velocity;

	CollisionShape2D* collision_shape;
    RectangleShape2D* rectangle_shape;
    Sprite2D* sprite;

protected:
	static void _bind_methods();

public:
	Character();
	~Character();

    void _ready() override;
	void _process(double delta) override;
};

}

#endif