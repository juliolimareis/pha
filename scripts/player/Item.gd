extends Area2D

class_name Item

enum typeItem { pokeball, potion, tm, revive }

export (int) var id = 0
export (String) var Name = ""
export (typeItem) var type = typeItem.pokeball
export (int) var countdown = 10

export (bool) var isDrop = false
export (int) var porcentProb = 45

var keyPos = ""
var keyTime = 'actions'

export var properties = {
	"cure": 0,
	"catch": 0,
	"idTm": 0,
	"revive": 2
}

signal action(isCountdown)

func _ready():
	if (isDrop):
		if (!Utils.prob(porcentProb)):
			queue_free()
	
	connect("body_entered", self, "_on_body_entered")
	add_to_group("item")

func action() -> void:
	pass
#	if !GlobalPlayer.isPvp:
#		match type:
#			typeItem.pokeball:
#				pokeball()
#			typeItem.potion:
#				cure()
#			typeItem.tm:
#				print("tm")
#			typeItem.revive:
#				revive()

func pokeball():
	pass
#	if Game.isAreaCatch && GlobalPlayer.isPlayerInvokedInBattle:
#		Game.getPlayer().attack()
#		GlobalPlayer.sumItem(id, -1)
#		emitAction(false)

func revive():
	pass
#	var dataPoke = GlobalPlayer.getDataPokeBagByPokeSelect()
#	if(dataPoke.acHp == 0):
#		var isCountdown = false
#		dataPoke.acHp = int(dataPoke.hp/properties.revive)
#
#		if(GlobalPlayer.isBattle):
#			Game._poke.pokeController.revive(dataPoke.acHp)
#			Time.start(keyTime, keyPos)
#			isCountdown = true
#
#		GlobalPlayer.sumItem(id, -1)
#		emitAction(isCountdown)
#		refreshProfilePoke()
#		Request.saveAcHp(dataPoke.idPokemon, dataPoke.acHp)

func cure() -> void:
	pass
#	var dataPoke = GlobalPlayer.getDataPokeBagByPokeSelect()
#	if(dataPoke.acHp > 0 && dataPoke.acHp != dataPoke.hp):
#		var isCountdown = false
#		dataPoke.acHp += properties.cure
#
#		if(dataPoke.acHp > dataPoke.hp):
#			dataPoke.acHp = dataPoke.hp
#
#		if is_instance_valid(Game._poke):
#			if Game._poke.id == dataPoke.idPokemon:
#				Game._poke.pokeController.getHealthBar().updated(dataPoke.acHp)
#				Game._poke.pokeController.setValueStatus("hp", dataPoke.acHp)
#
#		if(GlobalPlayer.isBattle):
#			isCountdown = true
#			Time.start(keyTime, keyPos)
#
#		GlobalPlayer.sumItem(id, -1)
#		emitAction(isCountdown)
#		refreshProfilePoke()
#		Request.saveAcHp(dataPoke.idPokemon, dataPoke.acHp)

func emitAction(isCountdown: bool):
	emit_signal("action", isCountdown)

func refreshProfilePoke():
	pass
#	GlobalPlayer.emitRefreshPokeProfiles()
#	GlobalPlayer.emitChangeActionSlot()

func _on_body_entered(body):
	if body.is_in_group("player_self"):
#		GlobalPlayer.addItem(self)
#		GlobalPlayer.emitChangeActionSlot()
		queue_free()
