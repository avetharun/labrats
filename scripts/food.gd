extends RigidBody3D

@export var animation : AnimationPlayer
@export var spoil_key : StringName = "spoil"
@export var lifetime : float = 10.0
@export var plays_spoil_animation : bool = true
func set_lifetime(time : float) -> void:
	self.lifetime = time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.animation_finished.connect(anim_finished)

func anim_finished(name:StringName):
	if name == spoil_key:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		animation.play(spoil_key)
	if global_position.y < -10:
		queue_free()
