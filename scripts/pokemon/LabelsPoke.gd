extends Node2D

@onready var thisPoke: Node = get_parent()

func _ready():
	if thisPoke.isBoss:
		$SkullDanger.visible = true
