extends OSCsender

onready var cube = $"MeshInstance"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here.
	set_process(true)

func _process(delta):
        cube.rotation_degrees.x += delta * 10
        msg_address("/from/godot")
        msg_add_string(name)
        msg_add_real(cube.rotation_degrees.x)
        msg_send()
