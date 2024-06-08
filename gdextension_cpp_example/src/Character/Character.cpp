#include "Character.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void Character::_bind_methods() {
    //ClassDB::bind_method(D_METHOD("_process", "delta"), &Character::_process);
    //ClassDB::bind_method(D_METHOD("_ready"), &Character::_ready);
}

Character::Character() {
    speed = 10;

     // Create the collision shape and rectangle shape
    collision_shape = memnew(CollisionShape2D);
    rectangle_shape = memnew(RectangleShape2D);

    // Set the size of the rectangle shape
    rectangle_shape->set_size(Vector2(16.0, 32.0)); // Adjust as needed

    // Assign the rectangle shape to the collision shape
    collision_shape->set_shape(rectangle_shape);
    collision_shape->set_name("Hi");


    // Add the collision shape as a child of the CustomPlayer node
    add_child(collision_shape);

    // Create the sprite
    sprite = memnew(Sprite2D);

    // Load the texture
    Ref<Texture2D> texture = ResourceLoader::get_singleton()->load("res://icon.svg");

    // Set the texture to the sprite
    sprite->set_texture(texture);

    // Add the sprite as a child of the CustomPlayer node
    add_child(sprite);
}

Character::~Character() {
    
}

void Character::_ready() {

}

void Character::_process(double delta) {
    Input* input = Input::get_singleton();
    if (input->is_action_pressed("ui_right")) {
        velocity.x += 1;
    }
    if (input->is_action_pressed("ui_left")) {
        velocity.x -= 1;
    }
    if (input->is_action_pressed("ui_down")) {
        velocity.y += 1;
    }
    if (input->is_action_pressed("ui_up")) {
        velocity.y -= 1;
    }

    // Normalize the velocity and then scale by the speed if there is any input
    // Normalize the velocity and then scale by the speed if there is any input
    if (velocity != get_velocity()) {
        velocity = velocity.normalized() * speed;
        UtilityFunctions::print("velocity: " + String(velocity));
    } else {
        UtilityFunctions::print("Enter here!");
        velocity = Vector2(0, 0); // Explicitly set velocity to zero if no input
    } 

    set_velocity(velocity);

    move_and_slide();
}
