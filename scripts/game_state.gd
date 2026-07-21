extends Node


const SAVE_PATH := "user://boro_save.json"
const LIMB_COUNT := 4

var current_level := "hub"
var valves: Array = [false, false, false]
var valve_progress := 0
var mirrors: Array = [0, 0, 0]
var music_progress := 0
var music_solved := false
var clock_weights: Array = [0, 0, 0]
var limbs_collected: Array = [false, false, false, false]
var limbs_returned: Array = [false, false, false, false]
var memory_threads: Array = [false, false, false, false]
var chapter_intro_seen: Array = [false, false, false, false]
var game_completed := false


func returned_count() -> int:
	return limbs_returned.count(true)


func collected_count() -> int:
	return limbs_collected.count(true)


func memory_count() -> int:
	return memory_threads.count(true)


func all_valves_open() -> bool:
	return valves.all(func(value): return value)


func mirrors_solved() -> bool:
	return mirrors == [1, 3, 2]


func clock_solved() -> bool:
	return clock_weights == [2, 0, 1]


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_game() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not open save file: %s" % SAVE_PATH)
		return false
	var data := {
		"version": 3,
		"current_level": current_level,
		"valves": valves,
		"valve_progress": valve_progress,
		"mirrors": mirrors,
		"music_progress": music_progress,
		"music_solved": music_solved,
		"clock_weights": clock_weights,
		"limbs_collected": limbs_collected,
		"limbs_returned": limbs_returned,
		"memory_threads": memory_threads,
		"chapter_intro_seen": chapter_intro_seen,
		"game_completed": game_completed,
	}
	file.store_string(JSON.stringify(data))
	return true


func load_game() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return false
	var save_version := int(parsed.get("version", 1))
	current_level = str(parsed.get("current_level", "hub"))
	valves = _safe_array(parsed.get("valves", []), [false, false, false])
	valve_progress = clampi(int(parsed.get("valve_progress", valves.count(true))), 0, 3)
	mirrors = _safe_array(parsed.get("mirrors", []), [0, 0, 0])
	music_progress = clampi(int(parsed.get("music_progress", 0)), 0, 4)
	music_solved = bool(parsed.get("music_solved", false))
	clock_weights = _safe_array(parsed.get("clock_weights", []), [0, 0, 0])
	limbs_collected = _safe_array(parsed.get("limbs_collected", []), [false, false, false, false])
	limbs_returned = _safe_array(parsed.get("limbs_returned", []), [false, false, false, false])
	memory_threads = _safe_array(parsed.get("memory_threads", []), [false, false, false, false])
	chapter_intro_seen = _safe_array(parsed.get("chapter_intro_seen", []), [false, false, false, false])
	game_completed = bool(parsed.get("game_completed", false))
	# Version 3 introduced ordered valves and linked mirrors. Reset only unfinished
	# legacy puzzles so an old partial state can never become unsolvable.
	if save_version < 3:
		if not all_valves_open():
			valves = [false, false, false]
			valve_progress = 0
		if not mirrors_solved():
			mirrors = [0, 0, 0]
	if current_level == "escape":
		current_level = "hub"
	return true


func reset_progress(delete_save := false) -> void:
	current_level = "hub"
	valves = [false, false, false]
	valve_progress = 0
	mirrors = [0, 0, 0]
	music_progress = 0
	music_solved = false
	clock_weights = [0, 0, 0]
	limbs_collected = [false, false, false, false]
	limbs_returned = [false, false, false, false]
	memory_threads = [false, false, false, false]
	chapter_intro_seen = [false, false, false, false]
	game_completed = false
	if delete_save and FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))


func _safe_array(value, fallback: Array) -> Array:
	if value is Array and value.size() == fallback.size():
		return value.duplicate()
	return fallback.duplicate()
