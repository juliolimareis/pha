extends Node2D

@export var color: Color = Color(1,0,0)

func _draw():
	draw_circle(Vector2.ZERO, 2, color)
