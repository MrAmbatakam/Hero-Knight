shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	pixelColor.rgb = mix(pixelColor.rgb, vec3(1,1,1).rgb, 0.5);
	//pixelColor = vec4(0.5,0,1,pixelColor.a);
	//COLOR = pixelColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
