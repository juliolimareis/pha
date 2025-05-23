extends Node2D

var keyTimeSwitch
var seconds = 1

var keyTime = "battle"
var keyPos = "switch"
#tempo para fazer nova troca
var countDownSwitch = 25

func _ready():
	GlobalPlayer.connect("change_poke", self, "_on_change_poke")
	GlobalPoke.connect("poke_dead", self, "_on_reset_time")
	Time.getTimer(keyTime, keyPos).connect("timeout", self, "_on_verify_countdown")

func _on_verify_countdown():
	if(seconds == 1):
		seconds = countDownSwitch
		Time.stop(keyTime, keyPos)
		countTime()
		visible = false
		Game.isSwitch = true
	else:
		seconds -= 1
		countTime()

func _on_reset_time(podeDead: Pokemon, xp):
	xp = xp
	if (podeDead.is_in_group("player_self")):
		seconds = 1

func countTime():
	$Time.text = str(seconds)

func _on_change_poke(dataPoke):
	if !GlobalPlayer.isPokeDeadById(dataPoke.idPokemon) && !GlobalPlayer.inWorld:
		seconds = countDownSwitch
		countTime()
		visible = true
