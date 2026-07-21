extends Node2D


const VIEWPORT_SIZE := Vector2(1280.0, 720.0)
const ESCAPE_WORLD_SIZE := Vector2(3840.0, 2160.0)
const ESCAPE_DURATION := 82.0
const LEVEL_ORDER := ["basement", "greenhouse", "music_room", "clocktower"]
const LEVEL_TITLES := {
	"hub": "縫線房",
	"basement": "第一章 · 沉水地下室",
	"greenhouse": "第二章 · 月光溫室",
	"music_room": "第三章 · 沉默樂室",
	"clocktower": "第四章 · 逆行鐘塔",
	"escape": "終章 · 房子醒了",
}
const LIMB_NAMES := ["左手", "右手", "左腳", "右腳"]
const BACKGROUNDS := {
	"hub": preload("res://art/concepts/hub-room-concept-v1.png"),
	"basement": preload("res://art/concepts/basement-pressure-concept-v1.png"),
	"greenhouse": preload("res://art/concepts/greenhouse-mirror-concept-v1.png"),
	"music_room": preload("res://art/concepts/music-room-concept-v1.png"),
	"clocktower": preload("res://art/concepts/clocktower-concept-v1.png"),
	"escape": preload("res://art/concepts/escape-collapse-concept-v1.png"),
}
const MUSIC_STREAMS := {
	"hub": preload("res://audio/music/hub-calm.ogg"),
	"basement": preload("res://audio/music/basement-dark.ogg"),
	"greenhouse": preload("res://audio/music/hub-calm.ogg"),
	"music_room": preload("res://audio/music/music-room.ogg"),
	"clocktower": preload("res://audio/music/clockwork.ogg"),
	"escape": preload("res://audio/music/escape-pursuit.wav"),
}
const SFX_STREAMS := {
	"confirm": preload("res://audio/sfx/ui-confirm.ogg"),
	"error": preload("res://audio/sfx/ui-error.ogg"),
	"interact": preload("res://audio/sfx/interact.ogg"),
	"mechanism": preload("res://audio/sfx/mechanism.ogg"),
	"pickup": preload("res://audio/sfx/pickup.ogg"),
	"impact": preload("res://audio/sfx/impact.ogg"),
	"door": preload("res://audio/sfx/door-open.ogg"),
	"cloth": preload("res://audio/sfx/cloth.ogg"),
	"creak": preload("res://audio/sfx/creak.ogg"),
}
const TEDDY_STATES := [
	preload("res://art/sprites/teddy/states/repair-state-0-v1.png"),
	preload("res://art/sprites/teddy/states/repair-state-1-v1.png"),
	preload("res://art/sprites/teddy/states/repair-state-2-v1.png"),
	preload("res://art/sprites/teddy/states/repair-state-3-v1.png"),
	preload("res://art/sprites/teddy/states/repair-state-4-v1.png"),
]
const LIMB_TEXTURES := [
	preload("res://art/sprites/teddy/left-arm-v1.png"),
	preload("res://art/sprites/teddy/right-arm-v1.png"),
	preload("res://art/sprites/teddy/left-leg-v1.png"),
	preload("res://art/sprites/teddy/right-leg-v1.png"),
]
const TEDDY_COMPLETE := preload("res://art/sprites/teddy/repaired-complete-v1.png")

const HUB_TEDDY_POINT := Vector2(640.0, 610.0)
const HUB_DOOR_POINTS := [
	Vector2(115.0, 615.0),
	Vector2(300.0, 615.0),
	Vector2(1000.0, 615.0),
	Vector2(1160.0, 615.0),
]
const EXIT_POINT := Vector2(60.0, 615.0)
const PICKUP_POINTS := {
	"basement": Vector2(1155.0, 605.0),
	"greenhouse": Vector2(1150.0, 605.0),
	"music_room": Vector2(1150.0, 605.0),
	"clocktower": Vector2(1130.0, 285.0),
}
const MEMORY_POINTS := {
	"basement": Vector2(790.0, 610.0),
	"greenhouse": Vector2(785.0, 610.0),
	"music_room": Vector2(640.0, 500.0),
	"clocktower": Vector2(1160.0, 610.0),
}
const VALVE_POINTS := [
	Vector2(330.0, 510.0), Vector2(640.0, 430.0), Vector2(950.0, 510.0),
]
const MIRROR_POINTS := [
	Vector2(290.0, 515.0), Vector2(620.0, 435.0), Vector2(940.0, 515.0),
]
const MUSIC_POINTS := [
	Vector2(245.0, 615.0), Vector2(500.0, 615.0),
	Vector2(760.0, 615.0), Vector2(1010.0, 615.0),
]
const MUSIC_ORDER := [0, 2, 1, 3]
const VALVE_ORDER := [1, 0, 2]
const CLOCK_POINTS := [
	Vector2(235.0, 530.0), Vector2(545.0, 450.0), Vector2(855.0, 370.0),
]
const ESCAPE_START := Vector2(105.0, 2100.0)
const ESCAPE_GOAL := Vector2(3680.0, 145.0)
const ESCAPE_CHECKPOINTS := [
	Vector2(105.0, 2100.0),
	Vector2(1265.0, 1660.0),
	Vector2(3185.0, 970.0),
]
const ESCAPE_MOVING_PLATFORM_SPECS := [
	{"rect": Rect2(745, 1835, 140, 22), "axis": Vector2.RIGHT, "distance": 72.0, "speed": 1.35, "phase": 0.2},
	{"rect": Rect2(1460, 1570, 126, 22), "axis": Vector2.DOWN, "distance": 58.0, "speed": 1.6, "phase": 1.3},
	{"rect": Rect2(2380, 1225, 122, 22), "axis": Vector2.RIGHT, "distance": 88.0, "speed": 1.55, "phase": 2.1},
	{"rect": Rect2(3330, 680, 126, 22), "axis": Vector2.RIGHT, "distance": 76.0, "speed": 1.8, "phase": 0.8},
	{"rect": Rect2(3095, 405, 108, 22), "axis": Vector2.DOWN, "distance": 52.0, "speed": 1.75, "phase": 2.7},
]
const ESCAPE_CRUMBLING_RECTS := [
	Rect2(1900, 1400, 112, 22),
	Rect2(2870, 1050, 138, 22),
	Rect2(3105, 595, 148, 22),
	Rect2(3310, 315, 136, 22),
]

@onready var player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var teddy: Sprite2D = $Teddy
@onready var limb_pickup: Sprite2D = $LimbPickup
@onready var teddy_escape: Sprite2D = $TeddyEscape
@onready var level_collision: Node2D = $LevelCollision
@onready var music: AudioStreamPlayer = $Music
@onready var sfx: AudioStreamPlayer = $SFX
@onready var objective_label: Label = $UI/TopBar/Objective
@onready var progress_label: Label = $UI/TopBar/Progress
@onready var hint_bar: ColorRect = $UI/HintBar
@onready var hint_label: Label = $UI/HintBar/Hint
@onready var message_panel: ColorRect = $UI/MessagePanel
@onready var message_label: Label = $UI/MessagePanel/Message
@onready var timer_label: Label = $UI/EscapeTimer
@onready var title_panel: ColorRect = $UI/TitlePanel
@onready var pause_panel: ColorRect = $UI/PausePanel
@onready var fail_panel: ColorRect = $UI/FailPanel
@onready var ending_panel: ColorRect = $UI/EndingPanel
@onready var ending_title: Label = $UI/EndingPanel/Title
@onready var ending_story: Label = $UI/EndingPanel/Story

var current_level := "hub"
var current_background: Texture2D = BACKGROUNDS["hub"]
var platform_rects: Array[Rect2] = []
var water_surface := 525.0
var title_active := true
var paused := false
var dialogue_active := false
var dialogue_lines: Array[String] = []
var dialogue_index := 0
var dialogue_after := Callable()
var message_time_left := 0.0
var escape_time_left := ESCAPE_DURATION
var debris_spawn_time := 0.0
var debris: Array[Dictionary] = []
var moving_platforms: Array[Dictionary] = []
var crumbling_platforms: Array[Dictionary] = []
var escape_checkpoint_index := 0
var escape_hit_cooldown := 0.0
var escape_elapsed := 0.0
var escape_failed := false
var ending_active := false
var debug_testing := false
var audio_muted := false
var limb_reveal_time := 0.0
var limb_reveal_index := -1
var using_touch_controls := false


func _ready() -> void:
	_ensure_input_actions()
	using_touch_controls = $UI/TouchControls.touch_mode
	if using_touch_controls:
		$UI/Controls.visible = false
		$UI/TitlePanel/Menu.text = "[互動] 繼續遊戲\n[跳躍] 開始新遊戲"
		$UI/TitlePanel/Credit.text = "建議橫向全螢幕遊玩 · 自動存檔"
		$UI/PausePanel/Text.text = "暫停\n\n[II] 繼續　[跳躍] 靜音 / 取消靜音\n[互動] 回到標題"
	camera.make_current()
	for scene_sprite in [teddy, limb_pickup, teddy_escape]:
		scene_sprite.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	player.player_fell.connect(_on_player_fell)
	load_level("hub", false)
	player.input_enabled = false
	_play_music("hub")
	_apply_debug_arguments()
	if "--debug-flow-test" in OS.get_cmdline_user_args() or "--debug-full-flow" in OS.get_cmdline_user_args():
		_run_debug_full_flow.call_deferred()
	elif "--debug-physics-test" in OS.get_cmdline_user_args():
		_run_debug_physics_test.call_deferred()
	else:
		for argument in OS.get_cmdline_user_args():
			if argument.begins_with("--capture="):
				_capture_debug_frame.call_deferred(argument.trim_prefix("--capture="))


func _process(delta: float) -> void:
	if limb_reveal_time > 0.0:
		limb_reveal_time = maxf(limb_reveal_time - delta, 0.0)
	if title_active:
		_process_title_input()
		queue_redraw()
		return

	if ending_active:
		if Input.is_action_just_pressed(&"ui_accept") or Input.is_action_just_pressed(&"interact"):
			_return_to_title()
		return

	if escape_failed:
		if Input.is_action_just_pressed(&"interact"):
			_restart_escape()
		return

	if Input.is_action_just_pressed(&"pause_menu") and not dialogue_active:
		_set_paused(not paused)
	if paused:
		if Input.is_action_just_pressed(&"mute_audio") or (using_touch_controls and Input.is_action_just_pressed(&"jump")):
			_toggle_mute()
		if Input.is_action_just_pressed(&"reset_prototype") or (using_touch_controls and Input.is_action_just_pressed(&"interact")):
			_return_to_title()
		return

	if Input.is_action_just_pressed(&"mute_audio"):
		_toggle_mute()

	if dialogue_active:
		if Input.is_action_just_pressed(&"interact") or Input.is_action_just_pressed(&"ui_accept"):
			_advance_dialogue()
		queue_redraw()
		return

	if Input.is_action_just_pressed(&"interact"):
		_handle_interaction()

	if current_level == "basement":
		var target_surface := 650.0 if GameState.all_valves_open() else 525.0
		water_surface = move_toward(water_surface, target_surface, delta * 95.0)
		player.water_line = water_surface
	elif current_level == "escape":
		_update_escape(delta)

	if message_time_left > 0.0:
		message_time_left -= delta
		if message_time_left <= 0.0:
			message_panel.visible = false
	_update_hint()
	_update_objective()
	queue_redraw()


func _physics_process(delta: float) -> void:
	if current_level == "escape" and not title_active and not paused \
			and not dialogue_active and not escape_failed and not ending_active:
		_update_escape_platforms(delta)
		_update_escape_camera(delta)


func _process_title_input() -> void:
	if Input.is_action_just_pressed(&"ui_accept") or Input.is_action_just_pressed(&"interact"):
		if not GameState.load_game():
			GameState.reset_progress()
		_start_game()
	elif Input.is_action_just_pressed(&"new_game") or (using_touch_controls and Input.is_action_just_pressed(&"jump")):
		GameState.reset_progress(true)
		_start_game()


func _start_game() -> void:
	title_active = false
	title_panel.visible = false
	ending_panel.visible = false
	ending_active = false
	player.input_enabled = true
	load_level(GameState.current_level if GameState.current_level in BACKGROUNDS else "hub", false)
	if GameState.returned_count() == 0 and GameState.collected_count() == 0:
		_start_dialogue([
			"明早，外婆的老屋就要拆了。小眠趁最後一夜，回來找一件忘了帶走的東西。",
			"房子裡只剩下倒著走的鐘聲。燈下，坐著一隻失去四肢的熊。",
			"波洛：我叫波洛……至少，我以前是。",
			"四條發亮的縫線伸進四個房間。每一條，都拴著小眠沒說完的一句再見。",
		])


func load_level(level_name: String, save_progress := true) -> void:
	current_level = level_name if level_name in BACKGROUNDS else "hub"
	GameState.current_level = current_level
	current_background = BACKGROUNDS[current_level]
	platform_rects = _platforms_for(current_level)
	position = Vector2.ZERO
	camera.offset = Vector2.ZERO
	camera.zoom = Vector2.ONE
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(ESCAPE_WORLD_SIZE.x if current_level == "escape" else VIEWPORT_SIZE.x)
	camera.limit_bottom = int(ESCAPE_WORLD_SIZE.y if current_level == "escape" else VIEWPORT_SIZE.y)

	if current_level == "basement":
		water_surface = 650.0 if GameState.all_valves_open() else 525.0
		player.water_line = water_surface
	else:
		player.water_line = 1.0e9

	var spawn := Vector2(390.0, 610.0)
	if current_level in LEVEL_ORDER:
		spawn = Vector2(110.0, 610.0)
	elif current_level == "escape":
		spawn = ESCAPE_START
	player.set_world_bounds(
		24.0,
		ESCAPE_WORLD_SIZE.x - 24.0 if current_level == "escape" else VIEWPORT_SIZE.x - 24.0,
		ESCAPE_WORLD_SIZE.y + 150.0 if current_level == "escape" else VIEWPORT_SIZE.y + 100.0
	)
	player.teleport_to(spawn)
	if current_level == "escape":
		camera.position = Vector2(
			clampf(spawn.x, VIEWPORT_SIZE.x * 0.5, ESCAPE_WORLD_SIZE.x - VIEWPORT_SIZE.x * 0.5),
			clampf(spawn.y - 90.0, VIEWPORT_SIZE.y * 0.5, ESCAPE_WORLD_SIZE.y - VIEWPORT_SIZE.y * 0.5)
		)
	else:
		camera.position = VIEWPORT_SIZE * 0.5

	_rebuild_collision()
	_refresh_scene_sprites()
	_play_music(current_level)
	_update_objective()
	if save_progress:
		_save_progress()
	_maybe_start_chapter_intro()
	queue_redraw()


func _platforms_for(level_name: String) -> Array[Rect2]:
	match level_name:
		"basement":
			return [Rect2(220, 550, 220, 24), Rect2(530, 470, 220, 24), Rect2(840, 550, 220, 24)]
		"greenhouse":
			return [Rect2(180, 550, 220, 24), Rect2(510, 470, 220, 24), Rect2(830, 550, 220, 24)]
		"music_room":
			return [Rect2(275, 540, 190, 24), Rect2(545, 500, 190, 24), Rect2(815, 540, 190, 24)]
		"clocktower":
			return [Rect2(120, 570, 230, 24), Rect2(430, 490, 230, 24), Rect2(740, 410, 230, 24), Rect2(1010, 330, 220, 24)]
		"escape":
			return [
				Rect2(235, 2010, 215, 22), Rect2(515, 1920, 170, 22),
				Rect2(970, 1740, 140, 22), Rect2(1170, 1660, 210, 22),
				Rect2(1680, 1490, 150, 22), Rect2(2090, 1320, 205, 22),
				Rect2(2605, 1140, 170, 22), Rect2(3100, 970, 185, 22),
				Rect2(3350, 870, 135, 22), Rect2(3545, 780, 190, 22),
				Rect2(2890, 500, 125, 22), Rect2(3515, 225, 210, 22),
			]
		_:
			return []


func _refresh_scene_sprites() -> void:
	teddy.visible = current_level == "hub"
	teddy.texture = TEDDY_STATES[GameState.returned_count()]
	teddy_escape.visible = current_level == "escape"
	teddy_escape.texture = TEDDY_COMPLETE
	if teddy_escape.visible:
		teddy_escape.global_position = player.global_position + Vector2(-65.0, -20.0)

	var level_index := LEVEL_ORDER.find(current_level)
	# The limb is the reward, never the premise: hide it fully until the room is solved.
	limb_pickup.visible = level_index >= 0 \
		and _puzzle_solved(current_level) \
		and not GameState.limbs_collected[level_index]
	if level_index >= 0:
		limb_pickup.texture = LIMB_TEXTURES[level_index]
		limb_pickup.global_position = PICKUP_POINTS[current_level]
		limb_pickup.scale = Vector2.ONE * 0.16
		limb_pickup.modulate = Color.WHITE


func _maybe_start_chapter_intro() -> void:
	var index := LEVEL_ORDER.find(current_level)
	if index < 0 or debug_testing or GameState.chapter_intro_seen[index]:
		return
	GameState.chapter_intro_seen[index] = true
	_save_progress()
	var intros: Array = [
		["雨水碰到膝蓋時，小眠想起：搬家那天，也下著這麼大的雨。", "波洛的聲音沿著管線傳來：先聽壓力計。它記得開閥的順序。"],
		["玻璃屋裡沒有風，枯葉卻全朝門外。外婆以前說，修剪不是遺棄。", "三面鏡的根纏在一起：外側牽動中央，中央會牽動全部。"],
		["四個音盒少了一個聽眾。牆上還留著小眠兒時寫的四個字。", "低、亮、暖、遠——是她和波洛才能聽懂的搖籃曲。"],
		["鐘塔沒有讓時間倒流，只是不肯替停在原地的人往前。", "晨光升到最高，午夜沉到底，星辰停在兩者之間。"],
	][index]
	_start_dialogue(intros)


func _handle_interaction() -> void:
	if current_level == "hub":
		_handle_hub_interaction()
	elif current_level == "escape":
		if player.global_position.distance_to(ESCAPE_GOAL) < 115.0:
			_complete_game()
		else:
			show_message("出口在右上方。波洛正跟著你。", 2.2)
	else:
		_handle_chapter_interaction()


func _handle_hub_interaction() -> void:
	if player.global_position.distance_to(HUB_TEDDY_POINT) < 125.0:
		var pending_limb := _pending_return_index()
		if pending_limb >= 0:
			_return_limb(pending_limb)
		elif GameState.returned_count() == 4:
			_start_dialogue([
				"波洛站了起來。遠處的鐘，第一次往前走了一格。",
				"波洛：小眠，門外才是真正的早晨。跑的時候，不要回頭。",
			], _begin_escape)
		else:
			var next_index := GameState.returned_count()
			show_message("波洛：下一條縫線，通往「%s」。" % LEVEL_TITLES[LEVEL_ORDER[next_index]], 3.0)
		return

	var closest_door := -1
	var closest_distance := 9999.0
	for index in HUB_DOOR_POINTS.size():
		var distance: float = player.global_position.distance_to(HUB_DOOR_POINTS[index])
		if distance < closest_distance:
			closest_distance = distance
			closest_door = index
	if closest_distance < 105.0:
		if closest_door <= GameState.returned_count():
			_play_sfx("door")
			load_level(LEVEL_ORDER[closest_door])
			show_message(_chapter_entry_hint(closest_door), 3.6)
		else:
			_play_sfx("error")
			show_message("門上的縫線還沒有亮起。先把找到的肢體交還波洛。", 2.8)
		return
	show_message("靠近發亮的門或波洛，再%s。" % ("點互動" if using_touch_controls else "按 E"), 2.0)


func _handle_chapter_interaction() -> void:
	var chapter_index := LEVEL_ORDER.find(current_level)
	if chapter_index < 0:
		return

	if not GameState.memory_threads[chapter_index] and player.global_position.distance_to(MEMORY_POINTS[current_level]) < 75.0:
		GameState.memory_threads[chapter_index] = true
		_play_sfx("pickup")
		_save_progress()
		show_message("找到一段記憶線：%s" % _memory_text(chapter_index), 4.0)
		return

	match current_level:
		"basement":
			for index in VALVE_POINTS.size():
				if player.global_position.distance_to(VALVE_POINTS[index]) < 90.0:
					var expected := int(VALVE_ORDER[GameState.valve_progress]) if GameState.valve_progress < VALVE_ORDER.size() else -1
					if index == expected:
						GameState.valves[index] = true
						GameState.valve_progress += 1
						_play_sfx("mechanism")
						_save_progress()
						show_message("壓力吻合：%d / 3。管線裡傳來回應。" % GameState.valve_progress, 2.2)
						if GameState.all_valves_open():
							_complete_room_puzzle(chapter_index)
					elif GameState.valves[index]:
						show_message("這個閥門已經固定。下一個壓力記號還在閃。", 1.8)
					else:
						GameState.valves = [false, false, false]
						GameState.valve_progress = 0
						_play_sfx("error")
						_save_progress()
						show_message("壓力逆流，三個閥門彈回原位。讀法是 Ⅱ → Ⅰ → Ⅲ。", 3.0)
					return
		"greenhouse":
			for index in MIRROR_POINTS.size():
				if player.global_position.distance_to(MIRROR_POINTS[index]) < 90.0:
					if GameState.mirrors_solved():
						show_message("月光已經穩定。右側容器正等著你。", 2.0)
						return
					_rotate_linked_mirrors(index)
					_play_sfx("mechanism")
					_save_progress()
					if GameState.mirrors_solved():
						_complete_room_puzzle(chapter_index)
					else:
						show_message("根系牽動了相連的鏡面。讓三束月光同時對準金色刻痕。", 2.5)
					return
		"music_room":
			for index in MUSIC_POINTS.size():
				if player.global_position.distance_to(MUSIC_POINTS[index]) < 88.0:
					_play_music_note(index)
					return
		"clocktower":
			for index in CLOCK_POINTS.size():
				if player.global_position.distance_to(CLOCK_POINTS[index]) < 90.0:
					if GameState.clock_solved():
						show_message("時間已重新向前。頂層鳥籠正等著你。", 2.0)
						return
					GameState.clock_weights[index] = (int(GameState.clock_weights[index]) + 1) % 3
					_play_sfx("mechanism")
					_save_progress()
					if GameState.clock_solved():
						_complete_room_puzzle(chapter_index)
					else:
						show_message("配重 %d 現在位於刻度 %d。" % [index + 1, int(GameState.clock_weights[index]) + 1], 2.1)
					return

	var pickup_point: Vector2 = PICKUP_POINTS[current_level]
	if player.global_position.distance_to(pickup_point) < 105.0:
		if not _puzzle_solved(current_level):
			_play_sfx("error")
			show_message("容器仍被謎題鎖住。", 2.2)
		elif not GameState.limbs_collected[chapter_index]:
			GameState.limbs_collected[chapter_index] = true
			limb_pickup.visible = false
			_play_sfx("pickup")
			_save_progress()
			_start_dialogue(["找到了波洛的%s。縫線正指向左側出口。" % LIMB_NAMES[chapter_index]])
		else:
			show_message("這裡只剩下一小段溫暖的線。", 1.8)
		return

	if player.global_position.distance_to(EXIT_POINT) < 100.0:
		_play_sfx("door")
		load_level("hub")
		if GameState.limbs_collected[chapter_index] and not GameState.limbs_returned[chapter_index]:
			show_message("把%s交還給房間中央的波洛。" % LIMB_NAMES[chapter_index], 3.0)
		return

	show_message("留意發亮的機關、記憶線與左側出口。", 2.0)


func _play_music_note(station_index: int) -> void:
	if GameState.music_solved:
		show_message("四個音盒正唱著完整的搖籃曲。", 2.0)
		return
	var expected: int = int(MUSIC_ORDER[GameState.music_progress])
	_play_sfx("interact")
	if station_index == expected:
		GameState.music_progress += 1
		if GameState.music_progress >= MUSIC_ORDER.size():
			GameState.music_solved = true
			_complete_room_puzzle(LEVEL_ORDER.find(current_level))
		else:
			show_message("音符正確：%d / 4。牆上的星星暗示下一個位置。" % GameState.music_progress, 2.6)
	else:
		GameState.music_progress = 1 if station_index == MUSIC_ORDER[0] else 0
		_play_sfx("error")
		show_message("旋律斷了。記住順序：低、亮、暖、遠。", 2.8)
	_save_progress()


func _rotate_linked_mirrors(index: int) -> void:
	# Outer mirrors turn themselves and the centre; the centre turns all three.
	var affected: Array = [0, 1, 2] if index == 1 else [index, 1]
	for mirror_index in affected:
		GameState.mirrors[mirror_index] = (int(GameState.mirrors[mirror_index]) + 1) % 4


func _complete_room_puzzle(chapter_index: int) -> void:
	_play_sfx("confirm")
	_reveal_limb(chapter_index)
	_save_progress()
	if debug_testing:
		return
	var reveal_lines: Array = [
		["最後一道逆流退去。鐵籠裡原本只有黑暗，現在縫線把一隻左手慢慢織了出來。", "波洛：那隻手，曾經牽著你走過積水。"],
		["三束月光在枯花心臟相遇，右手像新芽一樣從光裡長出來。", "波洛：放開，不一定等於不要了。"],
		["最後一個音落下，玩具箱才有了內容：一隻被歌聲叫回來的左腳。", "波洛：你以前總把我踩在腳背上跳舞。"],
		["鐘針向前走了一格。空鳥籠裡，右腳隨第一聲正確的鐘響出現。", "波洛：時間不是把我帶走，它只是等你來道別。"],
	][chapter_index]
	_start_dialogue(reveal_lines)


func _reveal_limb(chapter_index: int) -> void:
	limb_reveal_index = chapter_index
	limb_reveal_time = 2.2
	_refresh_scene_sprites()
	limb_pickup.visible = true
	limb_pickup.scale = Vector2.ONE * 0.025
	limb_pickup.modulate = Color(1.0, 0.9, 0.55, 0.0)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(limb_pickup, "scale", Vector2.ONE * 0.18, 0.55) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(limb_pickup, "modulate", Color.WHITE, 0.35)
	tween.chain().tween_property(limb_pickup, "scale", Vector2.ONE * 0.16, 0.22)


func _return_limb(index: int) -> void:
	GameState.limbs_returned[index] = true
	_play_sfx("cloth")
	_refresh_scene_sprites()
	_save_progress()
	if debug_testing:
		return
	var story_lines: Array = [
		["小眠把左手縫回去。波洛輕輕握住她的指尖，像搬家那天以前一樣。", "波洛：你不是故意鬆手。那時候，你也只是個被大人抱走的孩子。"],
		["右手接上時，一片乾枯的葉子從掌心落下，又在地板上長出新芽。", "波洛：外婆說得對。好好告別，才不是遺棄。"],
		["左腳踩上地板，樂室的最後一個音符也跟著落下。小眠終於記起歌的下一句。", "波洛：你不是回來找玩具；你是回來接那個沒能離開的自己。"],
		["最後一針完成，整棟房子像吸了一口很深的氣。倒走的鐘第一次向前。", "波洛：我能走了。天亮前，讓我們一起跟這棟房子說再見。"],
	][index]
	_start_dialogue(story_lines)


func _pending_return_index() -> int:
	for index in GameState.limbs_collected.size():
		if GameState.limbs_collected[index] and not GameState.limbs_returned[index]:
			return index
	return -1


func _puzzle_solved(level_name: String) -> bool:
	match level_name:
		"basement": return GameState.all_valves_open()
		"greenhouse": return GameState.mirrors_solved()
		"music_room": return GameState.music_solved
		"clocktower": return GameState.clock_solved()
	return false


func _begin_escape() -> void:
	load_level("escape", false)
	escape_time_left = ESCAPE_DURATION
	debris_spawn_time = 0.6
	debris.clear()
	escape_checkpoint_index = 0
	escape_hit_cooldown = 1.0
	escape_elapsed = 0.0
	escape_failed = false
	fail_panel.visible = false
	timer_label.visible = true
	timer_label.modulate = Color.WHITE
	player.input_enabled = true
	player.set_respawn_position(ESCAPE_CHECKPOINTS[0])
	_play_sfx("creak")
	show_message("房子正在崩塌！沿著發亮縫線向右上攀爬；搖晃與碎裂的平台不會等你。", 4.5)


func _update_escape(delta: float) -> void:
	if player.global_position.distance_to(ESCAPE_GOAL) < 95.0:
		_complete_game()
		return

	escape_hit_cooldown = maxf(escape_hit_cooldown - delta, 0.0)
	escape_time_left -= delta
	timer_label.text = "逃離  %.1f　錨點 %d / %d" % [
		maxf(escape_time_left, 0.0), escape_checkpoint_index, ESCAPE_CHECKPOINTS.size() - 1
	]
	timer_label.modulate = Color(1.0, 0.45, 0.4) if escape_time_left <= 10.0 else Color.WHITE
	if escape_time_left <= 0.0:
		_fail_escape("鐘聲停了。房子吞沒了最後一階樓梯。")
		return

	for checkpoint_index in range(escape_checkpoint_index + 1, ESCAPE_CHECKPOINTS.size()):
		if player.global_position.distance_to(ESCAPE_CHECKPOINTS[checkpoint_index]) < 90.0:
			escape_checkpoint_index = checkpoint_index
			player.set_respawn_position(ESCAPE_CHECKPOINTS[checkpoint_index])
			_play_sfx("confirm")
			show_message("縫線錨點 %d / %d 已固定。跌落後會從這裡繼續。" % [
				checkpoint_index, ESCAPE_CHECKPOINTS.size() - 1
			], 2.8)
			break

	debris_spawn_time -= delta
	if debris_spawn_time <= 0.0:
		var camera_left := camera.position.x - VIEWPORT_SIZE.x * 0.5
		var camera_top := camera.position.y - VIEWPORT_SIZE.y * 0.5
		debris.append({
			"position": Vector2(
				clampf(randf_range(camera_left + 70.0, camera_left + VIEWPORT_SIZE.x - 70.0), 35.0, ESCAPE_WORLD_SIZE.x - 35.0),
				maxf(camera_top - 30.0, -30.0)
			),
			"speed": randf_range(255.0, 390.0),
			"radius": randf_range(10.0, 18.0),
		})
		var route_progress := clampf(1.0 - player.global_position.y / ESCAPE_WORLD_SIZE.y, 0.0, 1.0)
		debris_spawn_time = randf_range(0.42, 0.72) - route_progress * 0.12

	var body_head: Vector2 = player.global_position + Vector2(0.0, -88.0)
	var body_feet: Vector2 = player.global_position + Vector2(0.0, -18.0)
	for index in range(debris.size() - 1, -1, -1):
		debris[index]["position"].y += float(debris[index]["speed"]) * delta
		var debris_position: Vector2 = debris[index]["position"]
		var closest := Geometry2D.get_closest_point_to_segment(debris_position, body_head, body_feet)
		if escape_hit_cooldown <= 0.0 and debris_position.distance_to(closest) < float(debris[index]["radius"]) + 17.0:
			_respawn_escape_at_checkpoint("落下的橫樑撞散了縫線。")
			return
		if debris_position.y > minf(camera.position.y + VIEWPORT_SIZE.y * 0.75, ESCAPE_WORLD_SIZE.y + 100.0):
			debris.remove_at(index)

	var follow_side := -1.0 if not player.animated_sprite.flip_h else 1.0
	var follow_target: Vector2 = player.global_position + Vector2(62.0 * follow_side, -20.0)
	teddy_escape.global_position = teddy_escape.global_position.lerp(follow_target, minf(delta * 4.2, 1.0))
	teddy_escape.global_position.x = clampf(teddy_escape.global_position.x, 58.0, ESCAPE_WORLD_SIZE.x - 58.0)
	teddy_escape.flip_h = player.animated_sprite.flip_h
	var shake := 1.2 + (1.0 - clampf(escape_time_left / ESCAPE_DURATION, 0.0, 1.0)) * 2.2
	camera.offset = Vector2(randf_range(-shake, shake), randf_range(-shake * 0.7, shake * 0.7))


func _update_escape_camera(delta: float) -> void:
	var look_ahead := clampf(player.velocity.x * 0.32, -105.0, 105.0)
	var target: Vector2 = player.global_position + Vector2(look_ahead, -85.0)
	target.x = clampf(target.x, VIEWPORT_SIZE.x * 0.5, ESCAPE_WORLD_SIZE.x - VIEWPORT_SIZE.x * 0.5)
	target.y = clampf(target.y, VIEWPORT_SIZE.y * 0.5, ESCAPE_WORLD_SIZE.y - VIEWPORT_SIZE.y * 0.5)
	camera.position = camera.position.lerp(target, minf(delta * 4.8, 1.0))


func _respawn_escape_at_checkpoint(reason: String) -> void:
	if escape_failed or ending_active:
		return
	escape_time_left -= 7.0
	if escape_time_left <= 0.0:
		_fail_escape("%s 鐘聲也在此刻停了。" % reason)
		return
	escape_hit_cooldown = 1.4
	debris.clear()
	var checkpoint: Vector2 = ESCAPE_CHECKPOINTS[escape_checkpoint_index]
	player.teleport_to(checkpoint)
	player.set_respawn_position(checkpoint)
	teddy_escape.global_position = checkpoint + Vector2(-62.0, -20.0)
	camera.position = Vector2(
		clampf(checkpoint.x, VIEWPORT_SIZE.x * 0.5, ESCAPE_WORLD_SIZE.x - VIEWPORT_SIZE.x * 0.5),
		clampf(checkpoint.y - 85.0, VIEWPORT_SIZE.y * 0.5, ESCAPE_WORLD_SIZE.y - VIEWPORT_SIZE.y * 0.5)
	)
	_play_sfx("impact")
	show_message("%s 回到縫線錨點，失去 7 秒。" % reason, 2.6)


func _fail_escape(reason: String) -> void:
	escape_failed = true
	camera.offset = Vector2.ZERO
	player.input_enabled = false
	fail_panel.visible = true
	$UI/FailPanel/Text.text = "%s\n\n%s 從逃生起點重試" % [reason, _interact_prompt()]
	_play_sfx("impact")


func _restart_escape() -> void:
	escape_failed = false
	fail_panel.visible = false
	_begin_escape()


func _complete_game() -> void:
	if ending_active:
		return
	camera.offset = Vector2.ZERO
	ending_active = true
	GameState.game_completed = true
	GameState.current_level = "hub"
	_save_progress()
	player.input_enabled = false
	timer_label.visible = false
	ending_panel.visible = true
	_play_sfx("confirm")
	_play_music("hub")
	if GameState.memory_count() == 4:
		ending_title.text = "完整結局 · 記住名字"
		ending_story.text = "晨光裡，小眠終於記起熊完整的名字——波洛。\n\n她在拆除圍籬外停下，向老屋、外婆，也向當年被抱上車的自己，好好說了再見。\n房子不再需要替她保管那場雨。這一次，記憶會跟著她往前走。"
	else:
		ending_title.text = "結局 · 帶你回家"
		ending_story.text = "小眠抱著波洛跨出門。老屋在晨霧裡安靜下來。\n\n她還沒有想起全部，但這次終於能說：我不是來把你留下，我是來帶你離開。\n（找到四個隱藏的記憶線，可開啟完整結局。）"


func _update_hint() -> void:
	if title_active or paused or dialogue_active or escape_failed or ending_active:
		hint_bar.visible = false
		return
	var hint := ""
	var interact := _interact_prompt()
	if current_level == "hub":
		if player.global_position.distance_to(HUB_TEDDY_POINT) < 125.0:
			hint = "%s 交還肢體" % interact if _pending_return_index() >= 0 else ("%s 和波洛一起離開" % interact if GameState.returned_count() == 4 else "%s 和波洛說話" % interact)
		else:
			for index in HUB_DOOR_POINTS.size():
				if player.global_position.distance_to(HUB_DOOR_POINTS[index]) < 105.0:
					hint = "%s 進入「%s」" % [interact, LEVEL_TITLES[LEVEL_ORDER[index]]] if index <= GameState.returned_count() else "這扇門尚未甦醒"
					break
	elif current_level == "escape":
		pass
	else:
		var chapter_index := LEVEL_ORDER.find(current_level)
		if not GameState.memory_threads[chapter_index] and player.global_position.distance_to(MEMORY_POINTS[current_level]) < 75.0:
			hint = "%s 拾起隱藏的記憶線" % interact
		elif player.global_position.distance_to(PICKUP_POINTS[current_level]) < 105.0:
			hint = "%s 取回%s" % [interact, LIMB_NAMES[chapter_index]] if _puzzle_solved(current_level) else "%s 檢查封住的容器" % interact
		elif player.global_position.distance_to(EXIT_POINT) < 100.0:
			hint = "%s 回到縫線房" % interact
		else:
			hint = _near_puzzle_hint()
	hint_label.text = hint
	hint_bar.visible = not hint.is_empty()


func _near_puzzle_hint() -> String:
	var points: Array
	var action_text := ""
	match current_level:
		"basement": points = VALVE_POINTS; action_text = "轉動水壓閥"
		"greenhouse": points = MIRROR_POINTS; action_text = "旋轉月光鏡"
		"music_room": points = MUSIC_POINTS; action_text = "播放音盒"
		"clocktower": points = CLOCK_POINTS; action_text = "調整配重"
		_: return ""
	for index in points.size():
		if player.global_position.distance_to(points[index]) < 90.0:
			return "%s %s %d" % [_interact_prompt(), action_text, index + 1]
	return ""


func _interact_prompt() -> String:
	return "[互動]" if using_touch_controls else "[E]"


func _update_objective() -> void:
	if current_level == "escape":
		objective_label.text = "%s　穿越崩塌迴廊，抵達右上方晨光" % LEVEL_TITLES[current_level]
	elif current_level == "hub":
		var pending := _pending_return_index()
		if pending >= 0:
			objective_label.text = "%s　把%s交還波洛" % [LEVEL_TITLES[current_level], LIMB_NAMES[pending]]
		elif GameState.returned_count() == 4:
			objective_label.text = "%s　牽起波洛，離開這棟房子" % LEVEL_TITLES[current_level]
		else:
			var next := GameState.returned_count()
			objective_label.text = "%s　前往 %s" % [LEVEL_TITLES[current_level], LEVEL_TITLES[LEVEL_ORDER[next]]]
	else:
		var index := LEVEL_ORDER.find(current_level)
		if GameState.limbs_collected[index]:
			objective_label.text = "%s　從左側出口帶回%s" % [LEVEL_TITLES[current_level], LIMB_NAMES[index]]
		elif _puzzle_solved(current_level):
			objective_label.text = "%s　謎題已解，取得%s" % [LEVEL_TITLES[current_level], LIMB_NAMES[index]]
		else:
			objective_label.text = "%s　%s" % [LEVEL_TITLES[current_level], _puzzle_objective(current_level)]
	if current_level == "escape":
		var height_progress := int(clampf(1.0 - player.global_position.y / ESCAPE_WORLD_SIZE.y, 0.0, 1.0) * 100.0)
		progress_label.text = "攀爬 %d%%　錨點 %d / %d" % [height_progress, escape_checkpoint_index, ESCAPE_CHECKPOINTS.size() - 1]
	else:
		progress_label.text = "縫線 %d / 4　記憶 %d / 4" % [GameState.returned_count(), GameState.memory_count()]


func _puzzle_objective(level_name: String) -> String:
	match level_name:
		"basement": return "依壓力紀錄開閥：Ⅱ → Ⅰ → Ⅲ（%d / 3）" % GameState.valve_progress
		"greenhouse": return "利用相連根系，讓三面鏡同時對準刻痕"
		"music_room": return "依線索重奏四個音盒（%d / 4）" % GameState.music_progress
		"clocktower": return "平衡三枚鐘塔配重"
	return "探索房子"


func show_message(text: String, duration := 2.5) -> void:
	if dialogue_active:
		return
	message_label.text = text
	message_time_left = duration
	message_panel.visible = true


func _start_dialogue(lines: Array, after := Callable()) -> void:
	dialogue_lines.clear()
	for line in lines:
		dialogue_lines.append(str(line))
	dialogue_index = 0
	dialogue_after = after
	dialogue_active = true
	message_time_left = 0.0
	player.input_enabled = false
	hint_bar.visible = false
	message_panel.visible = true
	message_label.text = "%s　%s" % [dialogue_lines[0], _interact_prompt()]


func _advance_dialogue() -> void:
	_play_sfx("interact")
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		message_label.text = "%s　%s" % [dialogue_lines[dialogue_index], _interact_prompt()]
		return
	dialogue_active = false
	message_panel.visible = false
	player.input_enabled = true
	var callback := dialogue_after
	dialogue_after = Callable()
	if callback.is_valid():
		callback.call()


func _set_paused(value: bool) -> void:
	paused = value
	pause_panel.visible = paused
	player.input_enabled = not paused
	player.set_physics_process(not paused)
	if paused:
		music.stream_paused = true
	else:
		music.stream_paused = false


func _toggle_mute() -> void:
	audio_muted = not audio_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), audio_muted)
	if not paused:
		show_message("聲音已關閉" if audio_muted else "聲音已開啟", 1.6)


func _return_to_title() -> void:
	paused = false
	pause_panel.visible = false
	fail_panel.visible = false
	ending_panel.visible = false
	ending_active = false
	escape_failed = false
	title_active = true
	title_panel.visible = true
	player.input_enabled = false
	player.set_physics_process(true)
	timer_label.visible = false
	camera.offset = Vector2.ZERO
	load_level("hub", false)


func _play_music(level_name: String) -> void:
	var stream: AudioStream = MUSIC_STREAMS.get(level_name, MUSIC_STREAMS["hub"])
	if music.stream == stream and music.playing:
		return
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	music.stream = stream
	music.play()


func _play_sfx(sound_name: String) -> void:
	if sound_name not in SFX_STREAMS:
		return
	sfx.stream = SFX_STREAMS[sound_name]
	sfx.pitch_scale = randf_range(0.97, 1.03)
	sfx.play()


func _rebuild_collision() -> void:
	moving_platforms.clear()
	crumbling_platforms.clear()
	for child in level_collision.get_children():
		child.free()
	var ground := Rect2(0.0, 660.0, 1280.0, 80.0)
	if current_level == "escape":
		ground = Rect2(0.0, 2100.0, 305.0, 100.0)
	_add_static_rect(ground)
	var wall_height := ESCAPE_WORLD_SIZE.y + 1200.0 if current_level == "escape" else 1400.0
	var right_wall_x := ESCAPE_WORLD_SIZE.x - 3.0 if current_level == "escape" else 1277.0
	_add_static_rect(Rect2(-77.0, -600.0, 80.0, wall_height))
	_add_static_rect(Rect2(right_wall_x, -600.0, 80.0, wall_height))
	for platform in platform_rects:
		_add_static_rect(platform, true)
	if current_level == "escape":
		for spec in ESCAPE_MOVING_PLATFORM_SPECS:
			_add_moving_platform(spec)
		for rect in ESCAPE_CRUMBLING_RECTS:
			_add_crumbling_platform(rect)


func _add_static_rect(rect: Rect2, one_way := false) -> void:
	var body := StaticBody2D.new()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	collision.position = rect.position + rect.size * 0.5
	collision.one_way_collision = one_way
	if one_way:
		collision.one_way_collision_margin = 6.0
	body.add_child(collision)
	level_collision.add_child(body)


func _add_moving_platform(spec: Dictionary) -> void:
	var rect: Rect2 = spec["rect"]
	var body := AnimatableBody2D.new()
	body.sync_to_physics = true
	body.position = rect.position + rect.size * 0.5
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	collision.one_way_collision = true
	collision.one_way_collision_margin = 8.0
	body.add_child(collision)
	level_collision.add_child(body)
	moving_platforms.append({
		"body": body,
		"origin": body.position,
		"size": rect.size,
		"axis": spec["axis"],
		"distance": spec["distance"],
		"speed": spec["speed"],
		"phase": spec["phase"],
	})


func _add_crumbling_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	collision.position = rect.position + rect.size * 0.5
	collision.one_way_collision = true
	collision.one_way_collision_margin = 7.0
	body.add_child(collision)
	level_collision.add_child(body)
	crumbling_platforms.append({
		"rect": rect,
		"collision": collision,
		"state": 0,
		"timer": 0.0,
	})


func _update_escape_platforms(delta: float) -> void:
	escape_elapsed += delta
	for platform in moving_platforms:
		var body: AnimatableBody2D = platform["body"]
		var origin: Vector2 = platform["origin"]
		var axis: Vector2 = platform["axis"]
		body.position = origin + axis * sin(escape_elapsed * float(platform["speed"]) + float(platform["phase"])) * float(platform["distance"])

	for index in crumbling_platforms.size():
		var platform: Dictionary = crumbling_platforms[index]
		var rect: Rect2 = platform["rect"]
		var state := int(platform["state"])
		if state == 0 and player.is_on_floor() \
				and player.global_position.x > rect.position.x - 10.0 \
				and player.global_position.x < rect.end.x + 10.0 \
				and absf(player.global_position.y - rect.position.y) < 7.0:
			platform["state"] = 1
			platform["timer"] = 0.55
			_play_sfx("creak")
		elif state == 1:
			platform["timer"] = float(platform["timer"]) - delta
			if float(platform["timer"]) <= 0.0:
				platform["state"] = 2
				platform["timer"] = 2.4
				var collision: CollisionShape2D = platform["collision"]
				collision.set_deferred(&"disabled", true)
		elif state == 2:
			platform["timer"] = float(platform["timer"]) - delta
			if float(platform["timer"]) <= 0.0:
				platform["state"] = 0
				platform["timer"] = 0.0
				var collision: CollisionShape2D = platform["collision"]
				collision.set_deferred(&"disabled", false)
		crumbling_platforms[index] = platform


func _draw() -> void:
	if current_level == "escape":
		_draw_escape_backdrop()
	else:
		draw_texture_rect(current_background, Rect2(Vector2.ZERO, VIEWPORT_SIZE), false)
	for platform in platform_rects:
		var platform_color := Color(0.18, 0.11, 0.07, 0.93)
		if current_level == "escape":
			platform_color = Color(0.20, 0.10, 0.065, 0.96)
		draw_rect(platform, platform_color, true)
		draw_line(platform.position, platform.position + Vector2(platform.size.x, 0), Color(0.78, 0.52, 0.27, 0.9), 4.0)
	if current_level == "escape":
		_draw_escape_platforms()

	match current_level:
		"hub": _draw_hub_doors()
		"basement": _draw_basement()
		"greenhouse": _draw_greenhouse()
		"music_room": _draw_music_room()
		"clocktower": _draw_clocktower()
		"escape": _draw_escape()

	var chapter_index := LEVEL_ORDER.find(current_level)
	if chapter_index >= 0 and not GameState.memory_threads[chapter_index]:
		_draw_memory_thread(MEMORY_POINTS[current_level])
	if limb_reveal_time > 0.0 and chapter_index == limb_reveal_index:
		_draw_limb_reveal(PICKUP_POINTS[current_level])


func _draw_hub_doors() -> void:
	var font := ThemeDB.fallback_font
	for index in HUB_DOOR_POINTS.size():
		var unlocked := index <= GameState.returned_count()
		var color := Color(0.95, 0.69, 0.30, 0.85) if unlocked else Color(0.25, 0.22, 0.2, 0.48)
		draw_arc(HUB_DOOR_POINTS[index] + Vector2(0, -45), 38.0, PI, TAU, 20, color, 4.0)
		draw_line(HUB_DOOR_POINTS[index] + Vector2(-38, -45), HUB_DOOR_POINTS[index] + Vector2(-38, 30), color, 4.0)
		draw_line(HUB_DOOR_POINTS[index] + Vector2(38, -45), HUB_DOOR_POINTS[index] + Vector2(38, 30), color, 4.0)
		draw_string(font, HUB_DOOR_POINTS[index] + Vector2(-8, 16), str(index + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, color)


func _draw_basement() -> void:
	if water_surface < 650.0:
		draw_rect(Rect2(0, water_surface, 1280, 660 - water_surface), Color(0.08, 0.40, 0.43, 0.5), true)
		draw_line(Vector2(0, water_surface), Vector2(1280, water_surface), Color(0.6, 0.9, 0.85, 0.8), 3.0)
	for index in VALVE_POINTS.size():
		_draw_valve(VALVE_POINTS[index], GameState.valves[index])
	draw_rect(Rect2(515, 155, 250, 48), Color(0.04, 0.035, 0.03, 0.78), true)
	draw_string(ThemeDB.fallback_font, Vector2(548, 188), "壓力紀錄　Ⅱ → Ⅰ → Ⅲ", HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color(0.92, 0.76, 0.46, 0.92))
	_draw_container(PICKUP_POINTS["basement"], GameState.all_valves_open())


func _draw_greenhouse() -> void:
	var receiver := Vector2(640.0, 610.0)
	var target_rotations := [1, 3, 2]
	for index in MIRROR_POINTS.size():
		var rotation := float(GameState.mirrors[index]) * PI * 0.5 - PI * 0.25
		var target_rotation := float(target_rotations[index]) * PI * 0.5 - PI * 0.25
		draw_circle(MIRROR_POINTS[index], 27.0, Color(0.08, 0.10, 0.11, 0.9))
		draw_line(MIRROR_POINTS[index] - Vector2.from_angle(rotation) * 25.0, MIRROR_POINTS[index] + Vector2.from_angle(rotation) * 25.0, Color(0.72, 0.92, 0.95, 0.95), 7.0)
		draw_line(MIRROR_POINTS[index] + Vector2.from_angle(target_rotation) * 32.0, MIRROR_POINTS[index] + Vector2.from_angle(target_rotation) * 42.0, Color(1.0, 0.73, 0.28, 0.95), 4.0)
		if GameState.mirrors_solved():
			draw_line(MIRROR_POINTS[index], receiver, Color(0.75, 0.95, 0.85, 0.65), 3.0)
	draw_circle(receiver, 18.0, Color(0.96, 0.86, 0.45, 0.85) if GameState.mirrors_solved() else Color(0.2, 0.28, 0.25, 0.8))
	_draw_container(PICKUP_POINTS["greenhouse"], GameState.mirrors_solved())


func _draw_music_room() -> void:
	var colors := [Color(0.55, 0.76, 0.9), Color(0.9, 0.58, 0.5), Color(0.85, 0.76, 0.4), Color(0.65, 0.52, 0.86)]
	var note_names := ["低", "暖", "亮", "遠"]
	for index in MUSIC_POINTS.size():
		draw_rect(Rect2(MUSIC_POINTS[index] + Vector2(-28, -45), Vector2(56, 45)), Color(0.12, 0.08, 0.07, 0.92), true)
		draw_circle(MUSIC_POINTS[index] + Vector2(0, -53), 11.0, colors[index] if GameState.music_solved else colors[index].darkened(0.35))
		draw_string(ThemeDB.fallback_font, MUSIC_POINTS[index] + Vector2(-9, -19), note_names[index], HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.94, 0.78, 0.48, 0.85))
	draw_rect(Rect2(445, 150, 390, 48), Color(0.04, 0.025, 0.035, 0.78), true)
	draw_string(ThemeDB.fallback_font, Vector2(510, 183), "搖籃曲　低 · 亮 · 暖 · 遠", HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color(0.88, 0.78, 0.96, 0.92))
	_draw_container(PICKUP_POINTS["music_room"], GameState.music_solved)


func _draw_clocktower() -> void:
	var weight_names := ["晨", "夜", "星"]
	for index in CLOCK_POINTS.size():
		var weight := int(GameState.clock_weights[index])
		var top: Vector2 = CLOCK_POINTS[index] + Vector2(0, -82)
		draw_line(top, top + Vector2(0, 52), Color(0.76, 0.62, 0.38, 0.9), 3.0)
		draw_rect(Rect2(CLOCK_POINTS[index] + Vector2(-20, -30 - weight * 12), Vector2(40, 35)), Color(0.42, 0.28, 0.16, 0.95), true)
		draw_string(ThemeDB.fallback_font, CLOCK_POINTS[index] + Vector2(-6, -6 - weight * 12), str(weight + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.98, 0.85, 0.62))
		draw_string(ThemeDB.fallback_font, CLOCK_POINTS[index] + Vector2(27, -48), weight_names[index], HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.96, 0.72, 0.35, 0.88))
	draw_rect(Rect2(430, 145, 420, 48), Color(0.04, 0.03, 0.02, 0.8), true)
	draw_string(ThemeDB.fallback_font, Vector2(475, 178), "晨光最高 · 午夜沉底 · 星辰居中", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.96, 0.75, 0.38, 0.94))
	_draw_container(PICKUP_POINTS["clocktower"], GameState.clock_solved())


func _draw_escape() -> void:
	for checkpoint_index in range(1, ESCAPE_CHECKPOINTS.size()):
		var checkpoint: Vector2 = ESCAPE_CHECKPOINTS[checkpoint_index]
		var reached := checkpoint_index <= escape_checkpoint_index
		var color := Color(0.62, 1.0, 0.78, 0.95) if reached else Color(1.0, 0.73, 0.32, 0.88)
		draw_line(checkpoint + Vector2(0, -8), checkpoint + Vector2(0, -92), color, 5.0)
		draw_circle(checkpoint + Vector2(0, -96), 18.0, Color(color, 0.2))
		draw_arc(checkpoint + Vector2(0, -96), 18.0, 0.0, TAU, 24, color, 4.0)
		draw_string(ThemeDB.fallback_font, checkpoint + Vector2(-58, -118), "縫線錨點 %d" % checkpoint_index, HORIZONTAL_ALIGNMENT_CENTER, 116.0, 17, color)
	draw_circle(ESCAPE_GOAL, 48.0, Color(1.0, 0.88, 0.58, 0.25))
	draw_arc(ESCAPE_GOAL, 50.0, 0.0, TAU, 32, Color(1.0, 0.9, 0.65, 0.9), 5.0)
	draw_string(ThemeDB.fallback_font, ESCAPE_GOAL + Vector2(-60, -65), "晨　光", HORIZONTAL_ALIGNMENT_CENTER, 120.0, 20, Color(1.0, 0.91, 0.66, 0.96))
	for piece in debris:
		var p: Vector2 = piece["position"]
		var radius := float(piece["radius"])
		draw_circle(p, radius, Color(0.24, 0.11, 0.07, 0.95))
		draw_line(p - Vector2(radius, radius * 0.4), p + Vector2(radius, radius * 0.4), Color(0.7, 0.35, 0.18, 0.9), 3.0)
	draw_rect(Rect2(Vector2.ZERO, ESCAPE_WORLD_SIZE), Color(0.25, 0.025, 0.0, 0.06), true)


func _draw_escape_backdrop() -> void:
	var columns := int(ceil(ESCAPE_WORLD_SIZE.x / VIEWPORT_SIZE.x))
	var rows := int(ceil(ESCAPE_WORLD_SIZE.y / VIEWPORT_SIZE.y))
	for row in rows:
		for column in columns:
			var tile_rect := Rect2(Vector2(column, row) * VIEWPORT_SIZE, VIEWPORT_SIZE)
			draw_texture_rect(current_background, tile_rect, false)
			var height_tint := float(rows - 1 - row) / maxf(float(rows - 1), 1.0)
			draw_rect(tile_rect, Color(0.18 + height_tint * 0.08, 0.025, 0.0, 0.12 + height_tint * 0.08), true)
	for x in range(1280, int(ESCAPE_WORLD_SIZE.x), 1280):
		draw_rect(Rect2(x - 12, 0, 24, ESCAPE_WORLD_SIZE.y), Color(0.08, 0.035, 0.025, 0.72), true)
	for y in range(720, int(ESCAPE_WORLD_SIZE.y), 720):
		draw_rect(Rect2(0, y - 9, ESCAPE_WORLD_SIZE.x, 18), Color(0.08, 0.035, 0.025, 0.68), true)


func _draw_escape_platforms() -> void:
	for platform in moving_platforms:
		var body: AnimatableBody2D = platform["body"]
		var size: Vector2 = platform["size"]
		var rect := Rect2(body.position - size * 0.5, size)
		draw_rect(rect, Color(0.18, 0.20, 0.16, 0.98), true)
		draw_line(rect.position, rect.position + Vector2(rect.size.x, 0), Color(0.66, 0.94, 0.65, 0.95), 4.0)
		draw_circle(rect.position + Vector2(12, rect.size.y * 0.5), 4.0, Color(0.86, 1.0, 0.72, 0.95))
		draw_circle(rect.end - Vector2(12, rect.size.y * 0.5), 4.0, Color(0.86, 1.0, 0.72, 0.95))
	for platform in crumbling_platforms:
		var rect: Rect2 = platform["rect"]
		var state := int(platform["state"])
		if state == 2:
			continue
		var pulse := 0.65 + sin(Time.get_ticks_msec() * 0.025) * 0.25 if state == 1 else 1.0
		draw_rect(rect, Color(0.28, 0.12, 0.07, 0.92 * pulse), true)
		draw_line(rect.position, rect.position + Vector2(rect.size.x, 0), Color(1.0, 0.45, 0.22, 0.95 * pulse), 4.0)
		for crack_x in range(18, int(rect.size.x), 30):
			draw_line(rect.position + Vector2(crack_x, 2), rect.position + Vector2(crack_x + 9, rect.size.y - 2), Color(0.08, 0.03, 0.02, 0.9), 2.0)


func _draw_valve(center: Vector2, opened: bool) -> void:
	var color := Color(0.35, 0.75, 0.48, 0.95) if opened else Color(0.76, 0.28, 0.20, 0.95)
	draw_circle(center, 30.0, Color(0.1, 0.07, 0.06, 0.94))
	draw_arc(center, 24.0, 0.0, TAU, 32, color, 7.0)
	for angle in [0.0, PI * 0.5, PI, PI * 1.5]:
		draw_line(center, center + Vector2.from_angle(angle) * 23.0, color, 5.0)
	draw_circle(center, 6.0, color)


func _draw_container(center: Vector2, unlocked: bool) -> void:
	var color := Color(0.85, 0.68, 0.36, 0.9) if unlocked else Color(0.37, 0.25, 0.17, 0.95)
	draw_rect(Rect2(center + Vector2(-50, -78), Vector2(100, 84)), color, false, 5.0)
	draw_line(center + Vector2(0, -78), center + Vector2(0, 6), color, 3.0)
	if not unlocked:
		draw_circle(center + Vector2(0, -34), 13.0, Color(0.07, 0.055, 0.045, 0.95))
		draw_arc(center + Vector2(0, -43), 8.0, PI, TAU, 12, Color(0.58, 0.42, 0.25, 0.95), 3.0)
		draw_rect(Rect2(center + Vector2(-8, -43), Vector2(16, 16)), Color(0.58, 0.42, 0.25, 0.95), true)


func _draw_limb_reveal(center: Vector2) -> void:
	var progress := 1.0 - limb_reveal_time / 2.2
	var pulse := sin(progress * PI * 5.0) * 4.0
	for ring in 3:
		var radius := 30.0 + progress * (55.0 + ring * 18.0) + pulse
		var alpha := maxf(0.0, (1.0 - progress) * (0.65 - ring * 0.12))
		draw_arc(center + Vector2(0, -35), radius, 0.0, TAU, 48, Color(1.0, 0.78, 0.35, alpha), 3.0)
	for angle_index in 8:
		var angle := float(angle_index) / 8.0 * TAU + progress
		var start := center + Vector2(0, -35) + Vector2.from_angle(angle) * 24.0
		draw_line(start, start + Vector2.from_angle(angle) * (18.0 + progress * 18.0), Color(1.0, 0.88, 0.55, 1.0 - progress), 2.0)


func _draw_memory_thread(center: Vector2) -> void:
	var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.004) * 0.18
	draw_circle(center, 20.0 * pulse, Color(0.95, 0.78, 0.44, 0.14))
	draw_circle(center, 7.0, Color(1.0, 0.9, 0.62, 0.95))
	draw_line(center + Vector2(-22, 13), center + Vector2(24, -15), Color(1.0, 0.82, 0.5, 0.82), 3.0)


func _chapter_entry_hint(index: int) -> String:
	return [
		"讀取壓力紀錄，依 Ⅱ → Ⅰ → Ⅲ 開啟三個水壓閥。",
		"鏡根彼此相連：外側帶動中央，中央帶動全部。",
		"按牆上的星位順序，重奏四個音盒。",
		"依晨光、午夜、星辰的線索調整三枚配重。",
	][index]


func _memory_text(index: int) -> String:
	return [
		"「那天不是你放開我。你在車窗裡一直拍玻璃，直到雨把我看不見。」",
		"「外婆剪下枯枝時說：讓它離開，也是照顧的一種。」",
		"「害怕的夜裡，你把我的腳放在腳背上，唱一首只屬於兩個人的歌。」",
		"「鐘沒有倒退。它只停在你來不及說再見的那一分鐘。」",
	][index]


func _save_progress() -> void:
	if not debug_testing:
		GameState.save_game()


func _on_player_fell() -> void:
	if current_level == "escape" and not escape_failed:
		_respawn_escape_at_checkpoint("樓梯在腳下碎裂了。")


func _ensure_input_actions() -> void:
	_ensure_action(&"move_left", [KEY_A, KEY_LEFT])
	_ensure_action(&"move_right", [KEY_D, KEY_RIGHT])
	_ensure_action(&"jump", [KEY_SPACE, KEY_W, KEY_UP])
	_ensure_action(&"interact", [KEY_E])
	_ensure_action(&"reset_prototype", [KEY_R])
	_ensure_action(&"new_game", [KEY_N])
	_ensure_action(&"pause_menu", [KEY_ESCAPE])
	_ensure_action(&"mute_audio", [KEY_M])


func _ensure_action(action_name: StringName, keycodes: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for keycode in keycodes:
		var already_added := false
		for existing_event in InputMap.action_get_events(action_name):
			if existing_event is InputEventKey and existing_event.physical_keycode == keycode:
				already_added = true
		if not already_added:
			var event := InputEventKey.new()
			event.physical_keycode = keycode
			InputMap.action_add_event(action_name, event)


func _apply_debug_arguments() -> void:
	var arguments := OS.get_cmdline_user_args()
	var debug_level := ""
	for level_name in LEVEL_ORDER + ["escape"]:
		if "--debug-%s" % level_name in arguments:
			debug_level = level_name
	if "--debug-escape-overview" in arguments:
		debug_level = "escape"
	if not debug_level.is_empty():
		debug_testing = true
		title_active = false
		title_panel.visible = false
		player.input_enabled = true
		if debug_level == "escape":
			GameState.limbs_returned = [true, true, true, true]
			_begin_escape()
			if "--debug-escape-overview" in arguments:
				camera.position = ESCAPE_WORLD_SIZE * 0.5
				camera.zoom = Vector2.ONE / 3.0
		else:
			load_level(debug_level, false)
	if "--debug-valves-open" in arguments:
		GameState.valves = [true, true, true]
		GameState.valve_progress = 3
		_refresh_scene_sprites()


func _run_debug_full_flow() -> void:
	debug_testing = true
	title_active = false
	title_panel.visible = false
	player.input_enabled = true
	GameState.reset_progress()

	load_level("basement", false)
	assert(not limb_pickup.visible, "Basement limb must stay hidden before puzzle completion")
	for valve_index in VALVE_ORDER:
		player.teleport_to(VALVE_POINTS[valve_index])
		_handle_interaction()
	assert(limb_pickup.visible, "Basement limb should reveal after puzzle completion")
	player.teleport_to(MEMORY_POINTS["basement"])
	_handle_interaction()
	player.teleport_to(PICKUP_POINTS["basement"])
	_handle_interaction()
	player.teleport_to(EXIT_POINT)
	_handle_interaction()
	player.teleport_to(HUB_TEDDY_POINT)
	_handle_interaction()

	load_level("greenhouse", false)
	assert(not limb_pickup.visible, "Greenhouse limb must stay hidden before puzzle completion")
	for index in MIRROR_POINTS.size():
		for turn in [1, 0, 2][index]:
			player.teleport_to(MIRROR_POINTS[index])
			_handle_interaction()
	assert(limb_pickup.visible, "Greenhouse limb should reveal after puzzle completion")
	player.teleport_to(MEMORY_POINTS["greenhouse"])
	_handle_interaction()
	player.teleport_to(PICKUP_POINTS["greenhouse"])
	_handle_interaction()
	player.teleport_to(EXIT_POINT)
	_handle_interaction()
	player.teleport_to(HUB_TEDDY_POINT)
	_handle_interaction()

	load_level("music_room", false)
	assert(not limb_pickup.visible, "Music-room limb must stay hidden before puzzle completion")
	for station in MUSIC_ORDER:
		player.teleport_to(MUSIC_POINTS[station])
		_handle_interaction()
	assert(limb_pickup.visible, "Music-room limb should reveal after puzzle completion")
	player.teleport_to(MEMORY_POINTS["music_room"])
	_handle_interaction()
	player.teleport_to(PICKUP_POINTS["music_room"])
	_handle_interaction()
	player.teleport_to(EXIT_POINT)
	_handle_interaction()
	player.teleport_to(HUB_TEDDY_POINT)
	_handle_interaction()

	load_level("clocktower", false)
	assert(not limb_pickup.visible, "Clocktower limb must stay hidden before puzzle completion")
	for index in CLOCK_POINTS.size():
		for turn in [2, 0, 1][index]:
			player.teleport_to(CLOCK_POINTS[index])
			_handle_interaction()
	assert(limb_pickup.visible, "Clocktower limb should reveal after puzzle completion")
	player.teleport_to(MEMORY_POINTS["clocktower"])
	_handle_interaction()
	player.teleport_to(PICKUP_POINTS["clocktower"])
	_handle_interaction()
	player.teleport_to(EXIT_POINT)
	_handle_interaction()
	player.teleport_to(HUB_TEDDY_POINT)
	_handle_interaction()

	assert(GameState.returned_count() == 4, "All four limbs should be returned")
	assert(GameState.memory_count() == 4, "All four memory threads should be collected")
	_begin_escape()
	player.teleport_to(ESCAPE_GOAL)
	_handle_interaction()
	assert(ending_active and GameState.game_completed, "The complete ending should trigger")
	print("BORO_COMPLETE_FLOW_OK: four puzzles -> four repairs -> escape -> true ending")
	music.stop()
	sfx.stop()
	player.footstep_audio.stop()
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit()


func _run_debug_physics_test() -> void:
	debug_testing = true
	title_active = false
	title_panel.visible = false
	player.input_enabled = true
	GameState.reset_progress()

	# 地下室（水中）：沿地面從最左走到最右，途中經過三座懸空平台下方，不可被卡住。
	load_level("basement", false)
	player.teleport_to(Vector2(40.0, 660.0))
	await get_tree().physics_frame
	Input.action_press(&"move_right")
	for frame in 480:
		await get_tree().physics_frame
	Input.action_release(&"move_right")
	assert(player.global_position.x > 1200.0,
		"walk under platforms should not snag (x=%.1f)" % player.global_position.x)

	# 地下室（水中）：從平台正下方原地起跳，應能穿過單向平台並站上平台頂（y=550）。
	player.teleport_to(Vector2(330.0, 660.0))
	await get_tree().physics_frame
	Input.action_press(&"jump")
	for frame in 40:
		await get_tree().physics_frame
	Input.action_release(&"jump")
	for frame in 90:
		await get_tree().physics_frame
	assert(player.is_on_floor() and absf(player.global_position.y - 550.0) < 2.0,
		"jump through one-way platform should land on top (y=%.1f)" % player.global_position.y)

	# 鐘塔（無水）：從地面跳上第一座平台頂（y=570）。
	load_level("clocktower", false)
	player.teleport_to(Vector2(235.0, 660.0))
	await get_tree().physics_frame
	Input.action_press(&"jump")
	for frame in 30:
		await get_tree().physics_frame
	Input.action_release(&"jump")
	for frame in 90:
		await get_tree().physics_frame
	assert(player.is_on_floor() and absf(player.global_position.y - 570.0) < 2.0,
		"dry jump should reach first clocktower platform (y=%.1f)" % player.global_position.y)

	# 左右邊界牆：持續往左推不可穿出畫面。
	Input.action_press(&"move_left")
	for frame in 150:
		await get_tree().physics_frame
	Input.action_release(&"move_left")
	assert(player.global_position.x >= 23.0,
		"left wall should stop the player (x=%.1f)" % player.global_position.x)

	print("BORO_PHYSICS_TEST_OK: no snags, one-way platforms, jump heights, walls")
	music.stop()
	sfx.stop()
	player.footstep_audio.stop()
	await get_tree().process_frame
	get_tree().quit()


func _capture_debug_frame(output_path: String) -> void:
	for frame in 12:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var error := image.save_png(output_path)
	print("BORO_CAPTURE_OK: %s (%s)" % [output_path, error_string(error)])
	get_tree().quit()
