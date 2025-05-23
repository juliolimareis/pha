extends Control

@onready var healthBar: ProgressBar = $ProgressBar
@onready var pulseTween = $PulseTween
@onready var updateTween = $UpdateTween
@onready var healthBarDamage: ProgressBar = $ProgressBarDamage

@export var healthyColor = Color.GREEN
@export var cautionColor = Color.YELLOW
@export var dangerColor = Color.RED
@export var pulseColor = Color.DARK_RED

@export_range( 0, 1, 0.05) var cautionZone = 0.5
@export_range (0, 1, 0.05) var dangerZone = 0.2

@export var willPulse = false

func updated(health: int) -> void:
	if(healthBar.value != health && health > 0):
		healthBar.value = health
		updateTween.interpolate_property(healthBarDamage, "value", healthBarDamage.value, health, 0.4, Tween.EASE_IN_OUT)
		updateTween.start()
		assignColor(health)
	elif(health <= 0):
		healthBar.value = 0
		healthBarDamage.value = 0


func assignColor(health: int) -> void:
	if health <= 0:
		if health < healthBar.max_value * dangerZone:
			healthBar.get_stylebox("fg").bg_color = dangerColor
		elif health < healthBar.max_value * cautionZone:
			healthBar.get_stylebox("fg").bg_color = cautionColor
		else:
			healthBar.get_stylebox("fg").bg_color = healthyColor

func initial(acHp: int, hp: int) -> void:
	healthBar.max_value = acHp
	healthBar.value = hp
	healthBarDamage.max_value = acHp
	healthBarDamage.value = hp
