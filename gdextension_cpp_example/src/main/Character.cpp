#include "../header/Character.hpp"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void Character::_bind_methods() {
}

Character::Character() {
    speed = 10;
    velocity = Vector2(0, 0);

    set_character_default();
}

Character::~Character() {
    
}

void Character::_ready() {

}

void Character::_process(double delta) {
    move();
}

void Character::move() {
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
    if (velocity != get_velocity()) {
        velocity = velocity.normalized() * speed;
    } else {
        velocity = Vector2(0, 0); // Explicitly set velocity to zero if no input
    } 

    set_velocity(velocity);

    move_and_slide();
}

void Character::set_character_default() {
    Vector2 viewport_size = get_viewport_rect().size;
    
    set_position(viewport_size / 2);
}
