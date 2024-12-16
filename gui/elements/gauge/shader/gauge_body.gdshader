shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 textureBefore = texture(TEXTURE, UV);
	vec4 cond1 = step(textureBefore, vec4(0.8975,0.895,0.9,1.0));
	textureBefore.a = textureBefore.a * cond1.r * cond1.g * cond1.b * cond1.a;
	COLOR = textureBefore;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
