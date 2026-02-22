class_name Effect
# More lightweight than Node
extends RefCounted

# Not a node, so no exported variable
var sound: AudioStream


# Virtual method, implementation in each children effect class
func execute(_targets: Array[Node]) -> void:
	pass
