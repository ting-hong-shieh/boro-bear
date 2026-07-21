extends Control


const BUTTONS := [
	{"name": "MoveLeft", "action": &"move_left", "center": Vector2(92, 608), "radius": 58.0, "label": "◀"},
	{"name": "MoveRight", "action": &"move_right", "center": Vector2(226, 608), "radius": 58.0, "label": "▶"},
	{"name": "Interact", "action": &"interact", "center": Vector2(1044, 610), "radius": 59.0, "label": "互動"},
	{"name": "Jump", "action": &"jump", "center": Vector2(1176, 558), "radius": 66.0, "label": "跳躍"},
	{"name": "Pause", "action": &"pause_menu", "center": Vector2(1218, 122), "radius": 38.0, "label": "II"},
]

var touch_mode := false


func _ready() -> void:
	touch_mode = _touch_input_available()
	visible = touch_mode
	if not touch_mode:
		return
	for config in BUTTONS:
		var button := TouchScreenButton.new()
		button.name = config["name"]
		button.position = config["center"]
		button.action = config["action"]
		button.passby_press = config["action"] in [&"move_left", &"move_right"]
		button.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
		var hit_shape := CircleShape2D.new()
		hit_shape.radius = config["radius"]
		button.shape = hit_shape
		add_child(button)
	queue_redraw()


func _touch_input_available() -> bool:
	if "--debug-touch" in OS.get_cmdline_user_args():
		return true
	if DisplayServer.is_touchscreen_available():
		return true
	if OS.has_feature("web"):
		var coarse_pointer = JavaScriptBridge.eval(
			"window.matchMedia('(pointer: coarse)').matches || navigator.maxTouchPoints > 0"
		)
		return bool(coarse_pointer)
	return false


func _draw() -> void:
	if not touch_mode:
		return
	var font := ThemeDB.fallback_font
	for config in BUTTONS:
		var center: Vector2 = config["center"]
		var radius: float = config["radius"]
		var is_utility: bool = config["action"] == &"pause_menu"
		var fill := Color(0.05, 0.04, 0.035, 0.62 if is_utility else 0.48)
		var outline := Color(1.0, 0.85, 0.56, 0.74)
		draw_circle(center, radius, fill)
		draw_arc(center, radius - 3.0, 0.0, TAU, 40, outline, 3.0)
		var label := str(config["label"])
		var font_size := 18 if is_utility else 22
		draw_string(
			font,
			center + Vector2(-radius, font_size * 0.36),
			label,
			HORIZONTAL_ALIGNMENT_CENTER,
			radius * 2.0,
			font_size,
			Color(1.0, 0.94, 0.82, 0.95)
		)
