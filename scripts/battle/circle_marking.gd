extends Node2D

export var color = Color(1,0,0)

func _draw():
	draw_circle(Vector2.ZERO, 10, color)
