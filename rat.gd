extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0
@export var target : Node3D
@export var move : bool = false
@export var jump_height : float = 1
func set_target(_target:Node3D) -> void:
	self.target = _target
	start_moving()
	update_target_location(_target.global_position)
func start_moving()->void:
	move = true
func start_moving_to(pos:Vector3)->void:
	nav_agent.target_position = pos
	move = true
func stop_moving()->void:
	move = false
@export var retarget_interval : float = 0.25
var retarget_duration : float = 0.25
func _physics_process(delta: float) -> void:
	if target == null:
		print("Target null, stopping moving")
		stop_moving()
	retarget_duration -= delta
	if retarget_duration <=0 and target != null:
		print("Retargeting")
		retarget_duration = retarget_interval
		if target:
			update_target_location(target.global_position)
	if move: 
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location-current_location).normalized() * SPEED
		
		#temporary value, will change later
		velocity=new_velocity
		if next_location != current_location:
			self.look_at(Vector3(next_location.x, position.y, next_location.z))
		if next_location.y > position.y:
			velocity += Vector3(0, jump_height, 0)
			
	#velocity += get_gravity()
	move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location
	start_moving()
