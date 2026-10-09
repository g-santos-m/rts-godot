class_name Printer
## Utilidad para formatear el texto impreso en Output.

var _node_name: String

func _init(node_name: String) -> void:
	_node_name = node_name

## Inserta el nombre del Nodo al inicio del string.
func cprint(...args: Array) -> void:
	print("[%s] " % _node_name, "".join(args))
