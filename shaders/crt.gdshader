shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D tex : hint_screen_texture, filter_nearest;

// Strength of scanline dimming (0 = none)
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.25;
// Phosphor mask intensity (0 = none, 1 = full)
uniform float mask_strength : hint_range(0.0, 1.0) = 0.4;
// Vignette darkening toward edges (0 = none)
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec4 col = texture(tex, SCREEN_UV);

	// Scanlines: darken every other pixel row
	float scan = 0.5 + 0.5 * sin(FRAGCOORD.y * PI);
	scan = mix(1.0, scan, scanline_strength);
	col.rgb *= scan;

	// Phosphor dot mask — RGB triads, offset on alternating rows
	int px = int(FRAGCOORD.x);
	int py = int(FRAGCOORD.y);
	int slot = (px + (py % 2)) % 3;
	vec3 mask_tint;
	if (slot == 0)      mask_tint = vec3(1.0, 0.15, 0.15);
	else if (slot == 1) mask_tint = vec3(0.15, 1.0, 0.15);
	else                mask_tint = vec3(0.15, 0.15, 1.0);

	// Preserve luminance so the mask doesn't darken the image overall
	float luma_before = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722));
	vec3 tinted = col.rgb * mask_tint;
	float luma_after = dot(tinted, vec3(0.2126, 0.7152, 0.0722));
	if (luma_after > 0.001) {
		tinted *= luma_before / luma_after;
	}
	col.rgb = mix(col.rgb, tinted, mask_strength);

	// Vignette: darken corners and edges
	vec2 vig_uv = SCREEN_UV * 2.0 - 1.0;
	float vig = 1.0 - dot(vig_uv, vig_uv) * vignette_strength;
	col.rgb *= clamp(vig, 0.0, 1.0);

	COLOR = col;
}
