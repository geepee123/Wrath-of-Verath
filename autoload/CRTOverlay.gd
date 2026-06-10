extends Node

var _crt_rect: ColorRect
var _options_layer: CanvasLayer
var _crt_check: CheckButton

func _ready() -> void:
	_build_crt_layer()
	_build_options_layer()
	_apply_settings()

func _build_crt_layer() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	_crt_rect = ColorRect.new()
	_crt_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_crt_rect.color = Color(0, 0, 0, 0)
	_crt_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var mat := ShaderMaterial.new()
	mat.shader = load("res://shaders/crt.gdshader")
	_crt_rect.material = mat

	layer.add_child(_crt_rect)

func _build_options_layer() -> void:
	_options_layer = CanvasLayer.new()
	_options_layer.layer = 101
	_options_layer.visible = false
	_options_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_options_layer)

	# Full-screen dim — absorbs clicks outside the panel
	var backdrop := ColorRect.new()
	backdrop.position = Vector2.ZERO
	backdrop.size = Vector2(1200, 700)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.65)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_options_layer.add_child(backdrop)

	# Centered panel: 400×300, centred at (600, 350)
	var panel := Panel.new()
	panel.position = Vector2(400, 200)
	panel.size = Vector2(400, 300)
	_options_layer.add_child(panel)

	# All children use explicit position + size — no anchors, no containers
	var title := Label.new()
	title.position = Vector2(16, 14)
	title.size = Vector2(368, 36)
	title.text = "Options"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	panel.add_child(title)

	var sep := ColorRect.new()
	sep.position = Vector2(16, 56)
	sep.size = Vector2(368, 2)
	sep.color = Color(0.45, 0.45, 0.45, 1.0)
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(sep)

	_crt_check = CheckButton.new()
	_crt_check.position = Vector2(16, 68)
	_crt_check.size = Vector2(368, 48)
	_crt_check.text = "  CRT Effect"
	_crt_check.toggled.connect(_on_crt_toggled)
	panel.add_child(_crt_check)

	var close_btn := Button.new()
	close_btn.position = Vector2(16, 236)
	close_btn.size = Vector2(368, 48)
	close_btn.text = "Close"
	close_btn.pressed.connect(close_options)
	panel.add_child(close_btn)

func _apply_settings() -> void:
	var enabled: bool = Global.user_settings_data.settings_crt_enabled
	_crt_rect.visible = enabled
	_crt_check.set_pressed_no_signal(enabled)

func open_options() -> void:
	_crt_check.set_pressed_no_signal(Global.user_settings_data.settings_crt_enabled)
	_options_layer.visible = true

func close_options() -> void:
	_options_layer.visible = false

func _on_crt_toggled(enabled: bool) -> void:
	_crt_rect.visible = enabled
	Global.user_settings_data.settings_crt_enabled = enabled
	FileLoader.save_user_settings()
