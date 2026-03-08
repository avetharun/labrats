extends Node3D

@export var camera: Camera3D
@export var selected_object: RigidBody3D
@export var object_array: Array[PackedScene]
@export var max_speed:= 8.0
@export var accel:= 5.0
var place_copy: bool = false
var food_location
var stored_position

func _physics_process(delta: float) -> void:
	
	var mouse_pos := get_viewport().get_mouse_position()
	
	var ray_start := camera.project_ray_origin(mouse_pos)
	var m_direction := camera.project_ray_normal(mouse_pos)
	
	
	var space_state := get_world_3d().direct_space_state
	
	var p := PhysicsRayQueryParameters3D.create(ray_start, ray_start+m_direction*1000, 1, [selected_object.get_rid()])
	
	var result := space_state.intersect_ray(p)
	
	if result and !place_copy:
		selected_object.visible = true
		selected_object.process_mode = Node.PROCESS_MODE_ALWAYS
		selected_object.position = result.position
	elif !result and !place_copy:
		selected_object.visible = false
		selected_object.process_mode = Node.PROCESS_MODE_DISABLED
		selected_object.gravity_scale = 0
	
	if Input.is_action_just_pressed("left_click"):
		place_copy = true
		stored_position = selected_object.position
	
	if Input.is_action_just_released("left_click"):
		place_copy = false
		if result:
			var new_obj = object_array[0].instantiate()
			add_child(new_obj)
			new_obj.get_child(0).set_deferred("disabled", false)
			new_obj.position = stored_position #+ (result.normal*0.25)
			
			var distance = stored_position.distance_to(result.position)
			var direction = -selected_object.transform.origin.direction_to(result.position)
			var speed = (distance*direction*accel).limit_length(max_speed)
			new_obj.apply_impulse(speed, Vector3.ZERO)
			get_tree().call_group("Rats", "set_target", new_obj)
