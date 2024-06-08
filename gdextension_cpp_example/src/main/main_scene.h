#ifndef MAIN_SCENE_H
#define MAIN_SCENE_H

#include <godot_cpp/classes/sprite2d.hpp>
#include "../Character/Character.h"

namespace godot {

class MainScene : public Node2D {
	GDCLASS(MainScene, Node2D)

private:
	Character* character;

protected:
	static void _bind_methods();

public:
	MainScene();
	~MainScene();

	void _process(double delta) override;
};

}

#endif