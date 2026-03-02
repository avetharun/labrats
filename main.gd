extends Node3D

@export var camera: Camera3D
@export var selected_object: RigidBody3D
@export var object_array: Array[PackedScene]
var place_copy: bool = false

func _physics_process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	
	var ray_start := camera.project_ray_origin(mouse_pos)
	var direction := camera.project_ray_normal(mouse_pos)
	
	
	var space_state := get_world_3d().direct_space_state
	
	var p := PhysicsRayQueryParameters3D.create(ray_start, ray_start+direction*1000, 1, [selected_object.get_rid()])
	
	var result := space_state.intersect_ray(p)
	
	if result && !place_copy:
		selected_object.visible = true
		selected_object.process_mode = Node.PROCESS_MODE_ALWAYS
		selected_object.position = result.position
	else:
		selected_object.visible = false
		selected_object.process_mode = Node.PROCESS_MODE_DISABLED
	
	if Input.is_action_just_pressed("left_click"):
		place_copy = true
		if result:
			var new_obj = object_array[0].instantiate()
			add_child(new_obj)
			new_obj.get_child(0).set_deferred("disabled", false)
			new_obj.position = result.position + (result.normal*0.25)
	
	if Input.is_action_just_released("left_click"):
		place_copy = false
