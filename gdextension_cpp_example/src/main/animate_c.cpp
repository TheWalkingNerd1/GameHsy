#include "../header/animate_c.hpp"


using namespace godot;

void Animated_C::_bind_methods() {
}

Animated_C::Animated_C() {
}

Animated_C::~Animated_C() {
    
}

void Animated_C::_ready() {

}

void Animated_C::_process(double delta) {
    Input* input = Input::get_singleton();
    if (input->is_action_pressed("ui_right")) {
        play("right");
    }
    if (input->is_action_pressed("ui_left")) {
        play("left");
    }
    if (input->is_action_pressed("ui_down")) {
        play("down");
    }
    if (input->is_action_pressed("ui_up")) {
        play("up");
    }

    // Normalize the velocity and then scale by the speed if there is any input
}