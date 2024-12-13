// SOURCE: https://www.youtube.com/watch?v=7nTQA_6CL6M

shader_type canvas_item;

uniform vec2 globalMousePosition;
uniform vec2 tileSize;

varying flat vec2 vertexPosition;

void vertex() {
	vertexPosition = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float isWithinY = step(globalMousePosition.y, vertexPosition.y) * step(vertexPosition.y - tileSize.y, globalMousePosition.y);
	float isWithinX = step(vertexPosition.x, globalMousePosition.x) * step(globalMousePosition.x, vertexPosition.x + tileSize.x);

	float isWithin = isWithinY * isWithinX;

	vec4 textureColor = texture(TEXTURE, UV);

	COLOR = mix(textureColor, vec4(0.7,0.0,0.0,1), 0.7*isWithin);
}