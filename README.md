# gdosc minimal setup

This project serves as a minimal example of OSC reception and transmission by using [gdosc](https://github.com/djiamnot/gdosc) module in [Godot game engine](https://godotengine.org). This project serves also a purpose of exposing a problem in the current implementation. The known issues will be addressed a little later, as a rewrite is planned to port the module to GDNative.

## Receiving OSC messages

In order to receive OSC messages you need to use `OSCreceiver` node. Please note, that this class ingerits from Godot's `Node` class, therefore in the current implementation it needs to be setup in a 3D environment. The module operates in two modes: _signal_ and _legacy_. By default the _signal_ mode is turned and it seems to be a natural and preferred way of using this module in Godot. This example covers only the _signal_ method.

For a more detailed explanation of the functionality, see the README in the _gdosc_'s root directory.

Currently, `OSCreceiver` node needs to have a script attached that activates `_process() ` which is usually done by implementing a `_ready()` method and executing `set_process(true)`. See [OSCreceiver](OSCreceiver.gd) script, which in the scene is attached to `OSCreceiver` node.

Another node will typically subscribe to `OSCreceiver`'s `_osc_message_received` signal. In this example, `OmniLight` node subscribes to this message (the connection is made via the editor). The script attached to this node [OmniLight.gd](OmniLight.gd) also needs to execute `set_process(true)` *and* implement `_process(delta)` method, even if it does not do anything:

``` python
func _process(delta):
        pass
```

This script will also needs to implement a callback to handle the signal, but that's standard GDScript practice, in this case, we do:

```python
func _on_OSCreceiver_osc_message_received(msg):
        if msg.address() == "/light/energy":
                var le = msg.arg(0)
                print("setting energy to ", le)
                light_energy = le
```

In this demo, sending an OSC message to localhost port: 2302 in the format `/light/energy 1.0` will result in setting `light_energy` property of `OmniLight` to 1.0.

This is workaround that is addressing the problem of the node needing to `process`.

## Sending OSC messages

See [OSCsender.gd](OSCsender.gd) script for an example of sending OSC message from a Godot node (`OSCsender` also inherits from `Node`). If set up an OSC receiver listening on port 28000, you will receive a message that looks like this `/from/godot sf "OSCsender" 57.367649` (this is an actual printout from liblo's _oscdump_, your output may be slightly different).

Many thanks to the user _SpotlightKid_ who has reported and documented this issue in [an issue](https://github.com/djiamnot/gdosc/commit/11744aa36c59864b4490614df3a62569618cab61) and a subsequent merge request. This and other issues will be addressed in the GDNative rewrite of gdosc.

Please, do not hesitate to report problems with this demo or gdosc module altogether.
