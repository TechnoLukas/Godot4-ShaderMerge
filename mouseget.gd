extends ColorRect

@export var sesetivity = 1.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse = self.get_local_mouse_position();
	var shaderSize = self.size;
	if(mouse.x>=0 && mouse.x<=shaderSize.x && mouse.y>=0 && mouse.y<=shaderSize.y): #hover mouse in window
		mouse = Vector2(shaderSize.x-self.get_local_mouse_position().x,shaderSize.y-self.get_local_mouse_position().y)
		material.set_shader_parameter("iMouse", mouse*sesetivity)
