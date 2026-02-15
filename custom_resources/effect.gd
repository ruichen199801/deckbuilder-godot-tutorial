class_name Effect
# More lightweight than Node
extends RefCounted

# Virtual method, implementation in each children effect class
func execute(_targets: Array[Node]) -> void:
	pass
