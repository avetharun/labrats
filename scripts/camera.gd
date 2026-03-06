class_name Camera extends Node3D
static var _singleton : Camera


@export var camera_node : Camera3D
@export var camera_pitch_node : Node3D
@export var camera_yaw_node : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_singleton = self
	pass # Replace with function body.
@export var enable_panning : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rot_goal *= 0.5
	pitch_goal *= 0.2
	camera_yaw_node.rotate_y(rot_goal * delta)
	camera_pitch_node.rotate_x(pitch_goal * delta)
	if Input.is_action_just_pressed("zoom_in"):
		camera_node.create_tween().tween_property(camera_node, "position", camera_node.position- Vector3(0, 1, 0), 0.05)
	if Input.is_action_just_pressed("zoom_out"):
		camera_node.create_tween().tween_property(camera_node, "position", camera_node.position+ Vector3(0, 1, 0), 0.05)
		
	pos_goal *= 0.1
	if enable_panning:
		translate(Vector3(pos_goal.x, 0, pos_goal.y).rotated(Vector3.UP, camera_yaw_node.rotation.y))
	else:
		position = Vector3.ZERO
var rot_goal : float = 0
var pitch_goal : float = 0

var pos_goal : Vector2 = Vector2.ZERO
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rel := event.screen_relative as Vector2
		if Input.is_action_pressed("right_click"):
			rot_goal=-rel.x * 5.0
			pitch_goal=-rel.y * 5.0
		elif Input.is_action_pressed("pan"):
			pos_goal = rel
			
		
