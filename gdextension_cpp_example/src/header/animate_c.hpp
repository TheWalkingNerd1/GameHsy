#ifndef ANIMATE_C_H
#define ANIMATE_C_H

#include <godot_cpp/classes/animated_sprite2d.hpp>
#include <godot_cpp/classes/input.hpp>

namespace godot {

class Animated_C : public AnimatedSprite2D{
	GDCLASS(Animated_C, AnimatedSprite2D)

private:

protected:
	static void _bind_methods();

public:
	Animated_C();
	~Animated_C();

    void _ready() override;
	void _process(double delta) override;
};

}

#endif