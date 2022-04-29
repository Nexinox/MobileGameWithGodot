extends Area2D

enum MODES {STATIC, LIMITED}

onready var orbit_position = $Pivot/OrbitingPosition

var radius = 100
var rotation_speed = PI
var mode
var current_orbits = 0
var num_orbits = 3
var orbit_start_position = null
var jumper = null

func init(_position, _radius=radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	
func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbits = num_orbits
			$Label.text = str(current_orbits)
			$Label.show()
	
func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
	
func check_orbits():
	if abs($Pivot.rotation - orbit_start_position) > 2*PI:
		current_orbits -= 1
		$Label.text = str(current_orbits)
		orbit_start_position = $Pivot.rotation
	
func implode():
	$AnimationPlayer.play("Implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func capture(target):
	jumper = target
	$Pivot.rotation = (jumper.position - position).angle()
	$AnimationPlayer.play("Capture")
	orbit_start_position = $Pivot.rotation
