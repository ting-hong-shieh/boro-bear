extends CharacterBody2D


signal player_fell

@export var move_speed := 300.0
@export var ground_acceleration := 2400.0
@export var ground_friction := 2900.0
@export var air_acceleration := 1500.0
@export var air_friction := 1100.0
@export var jump_velocity := -640.0
@export var rise_gravity := 1500.0
@export var fall_gravity := 2150.0
@export var apex_gravity_scale := 0.58
@export var apex_speed_threshold := 45.0
@export var max_fall_speed := 1250.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.12
@export var jump_cut_factor := 0.45

const DEFAULT_LEFT_LIMIT := 24.0
const DEFAULT_RIGHT_LIMIT := 1256.0
const DEFAULT_FALL_RESPAWN_Y := 820.0
const WATER_SUBMERGE_DEPTH := 12.0
const WATER_SPEED_SCALE := 0.7
const WATER_RISE_GRAVITY_SCALE := 0.8
const WATER_FALL_GRAVITY_SCALE := 0.4
const WATER_FALL_SPEED_SCALE := 0.35
const HARD_LANDING_SPEED := 420.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var footstep_audio: AudioStreamPlayer = $FootstepAudio

var input_enabled := true
var spawn_position := Vector2.ZERO
var world_left_limit := DEFAULT_LEFT_LIMIT
var world_right_limit := DEFAULT_RIGHT_LIMIT
var fall_respawn_y := DEFAULT_FALL_RESPAWN_Y
var water_line := 1.0e9
var in_water := false
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false
var base_sprite_scale := Vector2.ONE
var squash_tween: Tween
var footstep_time := 0.0
var footstep_index := 0
var footstep_streams: Array[AudioStream] = [
	preload("res://audio/sfx/footstep-1.ogg"),
	preload("res://audio/sfx/footstep-2.ogg"),
	preload("res://audio/sfx/footstep-3.ogg"),
	preload("res://audio/sfx/footstep-4.ogg"),
]


func _ready() -> void:
	_build_animations()
	animated_sprite.play(&"idle")
	animated_sprite.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	base_sprite_scale = animated_sprite.scale
	spawn_position = global_position


func _physics_process(delta: float) -> void:
	in_water = global_position.y > water_line + WATER_SUBMERGE_DEPTH
	var on_floor := is_on_floor()

	if on_floor:
		coyote_timer = coyote_time
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)
	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

	var direction := 0.0
	if input_enabled:
		direction = Input.get_axis(&"move_left", &"move_right")
		if Input.is_action_just_pressed(&"jump"):
			jump_buffer_timer = jump_buffer_time
		if Input.is_action_just_released(&"jump") and velocity.y < 0.0:
			velocity.y *= jump_cut_factor
	else:
		jump_buffer_timer = 0.0

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		on_floor = false
		_tween_sprite_scale(Vector2(0.92, 1.1), 0.18)

	var gravity := rise_gravity if velocity.y < 0.0 else fall_gravity
	if not on_floor and absf(velocity.y) < apex_speed_threshold:
		gravity *= apex_gravity_scale
	if in_water:
		gravity *= WATER_RISE_GRAVITY_SCALE if velocity.y < 0.0 else WATER_FALL_GRAVITY_SCALE
	if not on_floor:
		var fall_cap := max_fall_speed * (WATER_FALL_SPEED_SCALE if in_water else 1.0)
		velocity.y = minf(velocity.y + gravity * delta, fall_cap)

	var target_speed := direction * move_speed * (WATER_SPEED_SCALE if in_water else 1.0)
	var rate := ground_acceleration if on_floor else air_acceleration
	if absf(direction) <= 0.05:
		rate = ground_friction if on_floor else air_friction
	if in_water:
		rate *= 0.8
	velocity.x = move_toward(velocity.x, target_speed, rate * delta)

	var fall_speed := velocity.y
	move_and_slide()
	position.x = clampf(position.x, world_left_limit, world_right_limit)

	var floored := is_on_floor()
	if floored and not was_on_floor and fall_speed > HARD_LANDING_SPEED:
		_on_hard_landing(fall_speed)
	was_on_floor = floored

	if global_position.y > fall_respawn_y:
		player_fell.emit()
		teleport_to(spawn_position)

	_update_animation(direction)
	_update_footsteps(delta, direction)


func teleport_to(target: Vector2) -> void:
	global_position = target
	spawn_position = target
	velocity = Vector2.ZERO
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	reset_physics_interpolation()


func set_world_bounds(left_limit: float, right_limit: float, respawn_y: float) -> void:
	world_left_limit = left_limit
	world_right_limit = right_limit
	fall_respawn_y = respawn_y


func set_respawn_position(target: Vector2) -> void:
	spawn_position = target


func _on_hard_landing(fall_speed: float) -> void:
	var strength := clampf(inverse_lerp(300.0, max_fall_speed, fall_speed), 0.25, 1.0)
	_tween_sprite_scale(Vector2(1.0 + 0.16 * strength, 1.0 - 0.18 * strength), 0.16)
	footstep_audio.stream = footstep_streams[footstep_index % footstep_streams.size()]
	footstep_audio.pitch_scale = 0.72
	footstep_audio.play()
	footstep_index += 1
	footstep_time = 0.2


func _tween_sprite_scale(factor: Vector2, duration: float) -> void:
	if squash_tween and squash_tween.is_valid():
		squash_tween.kill()
	animated_sprite.scale = base_sprite_scale * factor
	squash_tween = create_tween()
	squash_tween.tween_property(animated_sprite, "scale", base_sprite_scale, duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _update_footsteps(delta: float, direction: float) -> void:
	if input_enabled and is_on_floor() and absf(direction) > 0.1 and absf(velocity.x) > 45.0:
		footstep_time -= delta
		if footstep_time <= 0.0:
			footstep_audio.stream = footstep_streams[footstep_index % footstep_streams.size()]
			footstep_audio.pitch_scale = randf_range(0.94, 1.06) * (0.85 if in_water else 1.0)
			footstep_audio.play()
			footstep_index += 1
			footstep_time = 0.4 if in_water else 0.31
	else:
		footstep_time = 0.0


func _update_animation(direction: float) -> void:
	if direction != 0.0:
		animated_sprite.flip_h = direction < 0.0

	var next_animation: StringName
	if not is_on_floor():
		next_animation = &"jump"
	elif absf(velocity.x) > 20.0:
		next_animation = &"walk"
	else:
		next_animation = &"idle"

	if animated_sprite.animation != next_animation:
		animated_sprite.play(next_animation)
	if next_animation == &"walk":
		animated_sprite.speed_scale = clampf(absf(velocity.x) / move_speed, 0.55, 1.0)
	else:
		animated_sprite.speed_scale = 1.0


func _build_animations() -> void:
	var frames := SpriteFrames.new()
	frames.remove_animation(&"default")
	_add_animation(frames, &"idle", [
		"res://art/sprites/protagonist/animation-v1/idle-01.png",
		"res://art/sprites/protagonist/animation-v1/idle-02.png",
	], 2.0, true)
	_add_animation(frames, &"walk", [
		"res://art/sprites/protagonist/animation-v1/walk-01.png",
		"res://art/sprites/protagonist/animation-v1/walk-02.png",
		"res://art/sprites/protagonist/animation-v1/walk-03.png",
		"res://art/sprites/protagonist/animation-v1/walk-02.png",
	], 7.0, true)
	_add_animation(frames, &"jump", [
		"res://art/sprites/protagonist/animation-v1/jump-01.png",
	], 1.0, false)
	animated_sprite.sprite_frames = frames


func _add_animation(
	frames: SpriteFrames,
	animation_name: StringName,
	texture_paths: Array,
	speed: float,
	looped: bool
) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, speed)
	frames.set_animation_loop(animation_name, looped)
	for texture_path in texture_paths:
		frames.add_frame(animation_name, load(texture_path) as Texture2D)
