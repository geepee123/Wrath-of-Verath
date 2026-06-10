extends Node

var _crt_rect: ColorRect
var _options_layer: CanvasLayer
var _crt_check: CheckButton
var _master_slider: HSlider
var _music_slider: HSlider
var _effects_slider: HSlider

func _ready() -> void:
	_ensure_audio_buses()
	_build_crt_layer()
	_build_options_layer()
	_apply_settings()

func _ensure_audio_buses() -> void:
	# Godot always has Master at index 0. Add Music and Effects buses if missing.
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "Music")
		AudioServer.set_bus_send(AudioServer.get_bus_count() - 1, "Master")
	if AudioServer.get_bus_index("Effects") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "Effects")
		AudioServer.set_bus_send(AudioServer.get_bus_count() - 1, "Master")

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

	# Centered panel: 400×420, centred at (600, 350)
	var panel := Panel.new()
	panel.position = Vector2(400, 140)
	panel.size = Vector2(400, 420)
	_options_layer.add_child(panel)

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
	_crt_check.size = Vector2(368, 40)
	_crt_check.text = "  CRT Effect"
	_crt_check.toggled.connect(_on_crt_toggled)
	panel.add_child(_crt_check)

	var sep2 := ColorRect.new()
	sep2.position = Vector2(16, 116)
	sep2.size = Vector2(368, 2)
	sep2.color = Color(0.45, 0.45, 0.45, 1.0)
	sep2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(sep2)

	var audio_title := Label.new()
	audio_title.position = Vector2(16, 124)
	audio_title.size = Vector2(368, 28)
	audio_title.text = "Volume"
	audio_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	audio_title.add_theme_font_size_override("font_size", 18)
	panel.add_child(audio_title)

	_master_slider = _build_volume_row(panel, "Master", 158, _on_master_volume_changed)
	_music_slider = _build_volume_row(panel, "Music", 230, _on_music_volume_changed)
	_effects_slider = _build_volume_row(panel, "Effects", 302, _on_effects_volume_changed)

	var close_btn := Button.new()
	close_btn.position = Vector2(16, 358)
	close_btn.size = Vector2(368, 48)
	close_btn.text = "Close"
	close_btn.pressed.connect(close_options)
	panel.add_child(close_btn)

func _build_volume_row(parent: Panel, label_text: String, y: int, callback: Callable) -> HSlider:
	var lbl := Label.new()
	lbl.position = Vector2(16, y)
	lbl.size = Vector2(120, 28)
	lbl.text = label_text
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(lbl)

	var slider := HSlider.new()
	slider.position = Vector2(140, y)
	slider.size = Vector2(244, 28)
	slider.min_value = 0
	slider.max_value = 10
	slider.step = 1
	slider.value_changed.connect(callback)
	parent.add_child(slider)

	var val_lbl := Label.new()
	val_lbl.position = Vector2(140, y + 28)
	val_lbl.size = Vector2(244, 20)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	val_lbl.add_theme_font_size_override("font_size", 11)
	parent.add_child(val_lbl)
	slider.set_meta("val_label", val_lbl)

	return slider

func _apply_settings() -> void:
	var s := Global.user_settings_data
	_crt_rect.visible = s.settings_crt_enabled
	_crt_check.set_pressed_no_signal(s.settings_crt_enabled)
	_set_slider_value(_master_slider, s.settings_audio_master_volume)
	_set_slider_value(_music_slider, s.settings_audio_music_volume)
	_set_slider_value(_effects_slider, s.settings_audio_effects_volume)
	_apply_bus_volume("Master", s.settings_audio_master_volume)
	_apply_bus_volume("Music", s.settings_audio_music_volume)
	_apply_bus_volume("Effects", s.settings_audio_effects_volume)

func _set_slider_value(slider: HSlider, value: int) -> void:
	slider.set_value_no_signal(value)
	var val_lbl: Label = slider.get_meta("val_label")
	val_lbl.text = str(value) + " / 10"

func _apply_bus_volume(bus_name: String, value: int) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	if value == 0:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(value / 10.0))

func open_options() -> void:
	_apply_settings()
	_options_layer.visible = true

func close_options() -> void:
	_options_layer.visible = false

func _on_crt_toggled(enabled: bool) -> void:
	_crt_rect.visible = enabled
	Global.user_settings_data.settings_crt_enabled = enabled
	FileLoader.save_user_settings()

func _on_master_volume_changed(value: float) -> void:
	var v := int(value)
	Global.user_settings_data.settings_audio_master_volume = v
	_set_slider_value(_master_slider, v)
	_apply_bus_volume("Master", v)
	FileLoader.save_user_settings()

func _on_music_volume_changed(value: float) -> void:
	var v := int(value)
	Global.user_settings_data.settings_audio_music_volume = v
	_set_slider_value(_music_slider, v)
	_apply_bus_volume("Music", v)
	FileLoader.save_user_settings()

func _on_effects_volume_changed(value: float) -> void:
	var v := int(value)
	Global.user_settings_data.settings_audio_effects_volume = v
	_set_slider_value(_effects_slider, v)
	_apply_bus_volume("Effects", v)
	FileLoader.save_user_settings()
