extends OmniLight

func _ready():
        set_process(true)

func _process(delta):
        pass

func _on_OSCreceiver_osc_message_received(msg):
        if msg.address() == "/light/energy":
                var le = msg.arg(0)
                print("setting energy to ", le)
                light_energy = le
