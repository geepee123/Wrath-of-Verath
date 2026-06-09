## Run once via Script → Run in the Godot script editor to generate placeholder PNG assets.
## Safe to delete after running.
@tool
extends EditorScript

const SZ := 48
const FG := Color.WHITE

func _run() -> void:
	_mkdir("res://external/sprites/ui/intent")
	_mkdir("res://external/sprites/ui/consumables")
	_mkdir("res://external/sprites/ui/hud")

	_gen("res://external/sprites/ui/intent/intent_attack.png",       Color(0.82, 0.15, 0.15), _draw_attack)
	_gen("res://external/sprites/ui/intent/intent_block.png",        Color(0.15, 0.35, 0.82), _draw_shield)
	_gen("res://external/sprites/ui/intent/intent_attack_block.png", Color(0.85, 0.48, 0.10), _draw_attack_block)
	_gen("res://external/sprites/ui/intent/intent_buff.png",         Color(0.15, 0.70, 0.25), _draw_arrow)
	_gen("res://external/sprites/ui/intent/intent_unknown.png",      Color(0.42, 0.42, 0.42), _draw_unknown)
	_gen("res://external/sprites/ui/consumables/consumable_slot.png",Color(0.18, 0.18, 0.28), _draw_flask)

	_gen("res://external/sprites/ui/hud/hud_energy.png",      Color(0.12, 0.50, 0.88), _draw_lightning)
	_gen("res://external/sprites/ui/hud/hud_draw_pile.png",   Color(0.18, 0.38, 0.68), _draw_draw_pile)
	_gen("res://external/sprites/ui/hud/hud_discard_pile.png",Color(0.38, 0.38, 0.48), _draw_discard_pile)
	_gen("res://external/sprites/ui/hud/hud_exhaust_pile.png",Color(0.62, 0.22, 0.08), _draw_exhaust_pile)
	_gen("res://external/sprites/ui/hud/hud_deck.png",        Color(0.18, 0.50, 0.32), _draw_deck)
	_gen("res://external/sprites/ui/hud/hud_pause.png",       Color(0.28, 0.28, 0.38), _draw_pause)
	_gen("res://external/sprites/ui/hud/hud_map.png",         Color(0.48, 0.32, 0.12), _draw_map)

	print("[PlaceholderGen] Done — 13 files written.")

# --- helpers ---

func _mkdir(path: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path))

func _gen(path: String, bg: Color, fn: Callable) -> void:
	var img := Image.create(SZ, SZ, false, Image.FORMAT_RGBA8)
	img.fill(bg)
	fn.call(img)
	img.save_png(ProjectSettings.globalize_path(path))
	print("[PlaceholderGen] ", path)

func _px(img: Image, x: int, y: int, c: Color) -> void:
	if x >= 0 and x < SZ and y >= 0 and y < SZ:
		img.set_pixel(x, y, c)

func _hspan(img: Image, y: int, x0: int, x1: int, c: Color, t: int = 2) -> void:
	for dy in t:
		for x in range(x0, x1 + 1):
			_px(img, x, y + dy, c)

func _vspan(img: Image, x: int, y0: int, y1: int, c: Color, t: int = 2) -> void:
	for dx in t:
		for y in range(y0, y1 + 1):
			_px(img, x + dx, y, c)

func _line(img: Image, x0: int, y0: int, x1: int, y1: int, c: Color, t: int = 2) -> void:
	var n := maxi(absi(x1 - x0), absi(y1 - y0))
	if n == 0:
		_px(img, x0, y0, c)
		return
	for i in n + 1:
		var f := float(i) / n
		var px := roundi(lerp(float(x0), float(x1), f))
		var py := roundi(lerp(float(y0), float(y1), f))
		for dy in t:
			for dx in t:
				_px(img, px + dx, py + dy, c)

func _fill_rect(img: Image, x0: int, y0: int, x1: int, y1: int, c: Color) -> void:
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			_px(img, x, y, c)

func _card(img: Image, x0: int, y0: int, x1: int, y1: int) -> void:
	_hspan(img, y0, x0, x1, FG); _hspan(img, y1, x0, x1, FG)
	_vspan(img, x0, y0, y1, FG); _vspan(img, x1, y0, y1, FG)

func _circle(img: Image, cx: int, cy: int, r: int, c: Color) -> void:
	for y in range(cy - r, cy + r + 1):
		for x in range(cx - r, cx + r + 1):
			if (x - cx) * (x - cx) + (y - cy) * (y - cy) <= r * r:
				_px(img, x, y, c)

# --- original intent / consumable shapes ---

func _draw_attack(img: Image) -> void:
	_line(img, 8, 8, 36, 36, FG, 3)
	_line(img, 36, 8, 8, 36, FG, 3)

func _draw_shield(img: Image) -> void:
	_hspan(img, 8, 10, 36, FG)
	_vspan(img, 10, 8, 30, FG)
	_vspan(img, 36, 8, 30, FG)
	_line(img, 10, 30, 22, 40, FG)
	_line(img, 37, 30, 24, 40, FG)

func _draw_attack_block(img: Image) -> void:
	_line(img, 5, 10, 18, 37, FG, 2)
	_line(img, 18, 10, 5, 37, FG, 2)
	_hspan(img, 10, 26, 41, FG)
	_vspan(img, 26, 10, 30, FG)
	_vspan(img, 41, 10, 30, FG)
	_line(img, 26, 30, 33, 40, FG)
	_line(img, 42, 30, 34, 40, FG)

func _draw_arrow(img: Image) -> void:
	_line(img, 22, 8, 7, 26, FG)
	_line(img, 22, 8, 37, 26, FG)
	_vspan(img, 21, 22, 39, FG, 4)

func _draw_unknown(img: Image) -> void:
	_hspan(img, 10, 17, 30, FG)
	_vspan(img, 30, 10, 21, FG)
	_hspan(img, 21, 20, 30, FG)
	_vspan(img, 20, 21, 29, FG)
	_hspan(img, 29, 20, 25, FG)
	for dy in 4:
		for dx in 4:
			_px(img, 21 + dx, 34 + dy, FG)

func _draw_flask(img: Image) -> void:
	var liq := Color(0.35, 0.65, 1.0, 0.75)
	_hspan(img, 7, 17, 28, FG)
	_vspan(img, 17, 7, 16, FG)
	_vspan(img, 28, 7, 16, FG)
	_line(img, 17, 16, 8, 39, FG)
	_line(img, 29, 16, 38, 39, FG)
	_hspan(img, 39, 8, 38, FG)
	for y in range(27, 39):
		var t := float(y - 16) / 23.0
		var hw := int(1.5 + t * 10.0)
		for x in range(24 - hw, 24 + hw):
			_px(img, x, y, liq)

# --- hud shapes ---

func _draw_lightning(img: Image) -> void:
	# lightning bolt (energy)
	_line(img, 27, 4, 14, 24, FG, 3)
	_line(img, 14, 24, 28, 24, FG, 3)
	_line(img, 28, 24, 16, 44, FG, 3)

func _draw_draw_pile(img: Image) -> void:
	# card outline + down arrow (draw = take cards from deck)
	_card(img, 7, 6, 38, 36)
	_vspan(img, 21, 12, 26, FG, 4)
	_line(img, 13, 24, 23, 34, FG)
	_line(img, 33, 24, 23, 34, FG)

func _draw_discard_pile(img: Image) -> void:
	# card outline + up arrow (discard = send cards away)
	_card(img, 7, 6, 38, 36)
	_vspan(img, 21, 16, 30, FG, 4)
	_line(img, 13, 20, 23, 10, FG)
	_line(img, 33, 20, 23, 10, FG)

func _draw_exhaust_pile(img: Image) -> void:
	# card outline + X (exhaust = removed permanently)
	_card(img, 7, 6, 38, 36)
	_line(img, 13, 12, 32, 30, FG)
	_line(img, 32, 12, 13, 30, FG)

func _draw_deck(img: Image) -> void:
	# 2x2 grid of small card shapes
	_card(img, 4, 4, 20, 20)
	_card(img, 26, 4, 42, 20)
	_card(img, 4, 26, 20, 42)
	_card(img, 26, 26, 42, 42)

func _draw_pause(img: Image) -> void:
	# two vertical bars (universal pause symbol)
	_fill_rect(img, 11, 9, 19, 38, FG)
	_fill_rect(img, 27, 9, 35, 38, FG)

func _draw_map(img: Image) -> void:
	# three nodes connected by paths
	_circle(img, 11, 11, 5, FG)
	_circle(img, 36, 20, 5, FG)
	_circle(img, 20, 38, 5, FG)
	_line(img, 11, 11, 36, 20, FG)
	_line(img, 36, 20, 20, 38, FG)
