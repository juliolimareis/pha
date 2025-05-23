extends Node

var pokeXp = PokemonXp.new()
# guarda temporariamente o pokémon que foi capiturado e enviado para a bag
var tempDataNewPokeInBag

#Sinais
# quando algum poke morre, (pokemon, quantidade de xp)
signal poke_dead(pokeDead, xp)

func _ready():
	pass
#	Server.connect("channel_other", self, "_on_channel_other")

#FIXME GlobalPoke receiver
func _on_channel_other(receiver):
	pass
#	if(receiver.type == "lvUpResponse"):
#		Game.notify("levelUp", Msg.levelUp(receiver.dataPlayer.nickname, receiver.dataPlayer.level))
#		getNewMove(receiver.dataPlayer)
#		refreshProfileScreen(receiver.dataPlayer.idPokemon, 'level', receiver.dataPlayer.level)
#	# quando o poke evolui
#	elif(receiver.type == "evolution"):
#		GlobalPlayer.setDataPokeBagById(receiver.dataPlayer.idPokemon, receiver.dataPlayer)
#		GlobalPlayer.emitRefreshPokeProfiles()
#		GlobalPlayer.emitChangeManPoke()
#
#	elif(receiver.type == "getXp"):
#		processXp(receiver.dataPlayer)
#
#	elif(receiver.type == "addLearnset"):
#		if(receiver.dataPlayer.size() > 0):
#			addLearnset(receiver.dataPlayer)
#
#	#FIXME receiver newPoke
#	# se chegou aqui, significa que este poke foi ganhado e deve estar na bag, 
#	elif(receiver.type == "newPoke"):
#		GlobalPlayer.addDataPokesBag(receiver.dataPlayer)
#		tempDataNewPokeInBag = receiver.dataPlayer
#		saveNotifyNewPoke(receiver.dataPlayer.nickname)
#		GlobalPlayer.emitRefreshPokeProfiles()
#		GlobalPlayer.emitChangeManPoke()
#
#	# se chegou aqui, significa que este poke foi capturado e deve estar na bag, 
#	elif(receiver.type == "newPokeCatch"):
#		GlobalPlayer.addDataPokesBag(receiver.dataPlayer)
#		tempDataNewPokeInBag = receiver.dataPlayer
#		# saveNotifyNewPokeCatch(receiver.dataPlayer[0].nickname)

func saveNotifyNewPoke(pokeName: String):
	var notify = {
		"type": "message",
		"text": Msg.newPoke(pokeName)
	}
#	Game.addNotify(notify)
#	Request.saveNotification()

func saveNotifyNewPokeCatch(pokeName: String):
	var notify = {
		"type": "message",
		"text": Msg.catch(pokeName)
	}
#	Game.addNotify(notify)
#	Request.saveNotification()

# Verifica e adiciona notificação de movimentos no painel
# recebe um array de moves
func addLearnset(arrMoves): #moveNotify
	pass
#	var dataPoke = GlobalPlayer.getDataPokeBagByCode(arrMoves[0].code)
#	var arrNewMoves = []
#
#	if dataPoke:
#		# verifica se esse poke tem algum ataque cadastrado
#		if(dataPoke.moveNotify.size() == 0):
#			for move in arrMoves:
#				setMovesInPainel(dataPoke, move)
#		else: # já tem ataques, add novos
#			for move in arrMoves:
#				# verifica se já tem esse ataque
#				if !verifyMoveInPokeMoveNotify(dataPoke, move.name):
#					arrNewMoves.push_back(move)
#
#		for move in arrNewMoves:
#			setMovesInPainel(dataPoke, move)
#
#		Game.notificationsMove = dataPoke.moveNotify
#
#		Request.saveNotification()
#		Request.saveMoveNotifi()

# adiciona nos paineis (movimento e notificação, não salvar salvar em -> Request.saveNotification() e saveMoveNotifi())
func setMovesInPainel(dataPoke, move) -> void:
	var notifi = {
		"type": "addMove",
		"moveName": move.name,
		"idPokemon": dataPoke.idPokemon,
		"text": Msg.addNotifyNewMove(dataPoke.nickname, move.name)
	}
#	Game.addNotify(notifi)
#	Game.addMoveNotifyInPoke(dataPoke, notifi)

func verifyMoveInPokeMoveNotify(dataPoke, moveName: String) -> bool:
	for move in dataPoke.moveNotify:
		if move.moveName == moveName:
			return true
	return false

func getNewMove(dataPlayer):
	pass
	#retorna no canal [addLearnset] no receiver
#	Request.getLearnset(dataPlayer.code, dataPlayer.level)

#verificar se pokeMain possui este movimento
func verifyMoveExistInPoke(moveName) -> bool:
	return false
#	var poke = GlobalPlayer.getDataPokeBag(0)
#	if (poke.move1 == moveName || poke.move2 == moveName || poke.move3 == moveName || poke.move4 == moveName):
#		return true
#	return false

#TODO poke dead
func emitPokeDead(pokeDead: Node2D, xp):
	pass
#	if(pokeDead.isMob):
#		var idPokePlayer = GlobalPlayer.getDataPokeBagByPokeSelect().idPokemon
#		GlobalPoke.saveEV(idPokePlayer, xp)
#		# GlobalPoke.saveXp(idPokePlayer, PokemonXp.new().getXp(xp))
#		var sendXp = PokemonXp.new().getXp(xp)
#		if(sendXp && sendXp > 0):
#			if(pokeDead.isBoss):
#				sendXp = sendXp*2
#			Request.setXp(idPokePlayer, sendXp)
#
#		Game.reduceQuantEnemies()
#
#		if Game.isAreaCatch:
#			pokeDead.add_to_group("poke_catch")
#			pokeDead.set_collision_layer_bit(7, true)
#	#FIXME pokemon player dead
#	elif(pokeDead.is_in_group("player_self") && !GlobalPlayer.isPvp):
#		if !Game.isExistOtherPokeAlive(pokeDead.id):
#			GlobalScene.toWorld()
#	emit_signal("poke_dead", pokeDead, xp)

# resposta do saveXP
func processXp(dataPlayer) -> void:
	pass
#	var pokeUp = GlobalPlayer.getPokeInstance(dataPlayer.idPokemon)
#	var isFinishCalc = true
#	var lv = dataPlayer.level
#	var xpNextLevel = pokeXp.getLimitLevel((lv+1), dataPlayer.lr)
#	var xp = dataPlayer.xp
#	var isUp = false
#
#	while(isFinishCalc):
#		if(xp >= xpNextLevel):
#			xpNextLevel = pokeXp.getLimitLevel((lv+2), dataPlayer.lr)
#			lv += 1
#			isUp = true
#		else: 
#			# print("[GlobalPoke] XP para próximo LV: ", xpNextLevel)
#			if(isUp):
#				# print("[GlobalPoke] level Up!")
#				upPoke(pokeUp, lv)
#				#poke.pokeController.setValueStatus("level", lv)
#			isFinishCalc = false
#			# print("[GlobalPoke] level atual: ", lv)
#
#	refreshProfileScreen(pokeUp.id, 'xp', xp)
	# print("[GlobalPoke] Total de xp: ", dataPlayer.xp)

func refreshProfileScreen(idPoke: int, key, val):
	pass
#	var dt = GlobalPlayer.getDataPokeBagById(idPoke)
#	dt[key] = val
#	GlobalPlayer.setDataPokeBagById(idPoke, dt)
#	GlobalPlayer.emitRefreshPokeProfiles()

func saveEV(idPoke: int, xp) -> void:
	pass
#	var dataStatusPoke = GlobalPlayer.getDataPokeBagById(idPoke)
#	var save = false
#
#	if(isMaxEv(dataStatusPoke['ev'])):
#		for key in xp['ev']:
#			if(key != 'exp'):
#				if(xp['ev'][key] != 0):
#					var sumEv = dataStatusPoke['ev'][key] + xp['ev'][key]
#					if(sumEv <= 255):
#						dataStatusPoke['ev'][key] = sumEv
#						save = true
#						# print("[GlobalPoke] Ganho de EV "+key+": ", xp['ev'][key])
#		if(save):
#			Request.saveEv(idPoke, dataStatusPoke['ev'])

# verifica se pode aumentar Ev(máximo por status 255, máximo da soma dos evs 510)
func isMaxEv(ev) -> bool:
	var total = 0
	for key in ev:
		if(key != "idEv" && key != "idPokemon"):
			total += ev[key]
	if(total <= 510):
		return true
	return false

#TODO upPoke
func upPoke(pokeUp, lv: int) -> void:
	pass
#	var dataStatusPoke = GlobalPlayer.getDataPokeBagById(pokeUp.id)
#	if(dataStatusPoke):
#		var statusBase = pokeUp.pokeStatus.statusBase
#		var newPoke = GeneratePokemon.new().create(statusBase, lv, dataStatusPoke.iv, dataStatusPoke.ev)
#		Request.setStatus(pokeUp.id, mountToSaveStatusPoke(pokeUp, newPoke))
#		if(pokeUp.id == Game.getPoke().id):
#			Game.getPoke().pokeController.refreshStatusDefault(newPoke.hp)
#			Game.getPoke().pokeController.setLabelLv(lv)

func evolution(idPoke: int):
	pass
#	if Game.isPokeInWorld:
#		Game.isPokeInWorld = false
#		Game.removePokeInstance()
#	var dataPoke = GlobalPlayer.getDataPokeBagById(idPoke)
#	var poke = getInstancePoke(dataPoke.code)
#	add_child(poke)
#	poke.visible = false
#	var newPoke = getInstancePoke(poke.pokeStatus.codeEvolution)
#	add_child(newPoke)
#	newPoke.visible = false
#	var statusBase = newPoke.pokeStatus.statusBase
#	var newStatusPoke = GeneratePokemon.new().create(statusBase, dataPoke.level, dataPoke.iv, dataPoke.ev)
#	var newValues = mountNewStatus(newStatusPoke, 0)
#	newValues['code'] = newPoke.pokeStatus.code
#
#	if(dataPoke.nickname == poke.pokeStatus.Name):
#		newValues['nickname'] = newPoke.pokeStatus.Name
#
#	refreshDataBagPoke(idPoke, newValues)
#	Request.setPokeChannel(idPoke, newValues, "evolution")
#	Game.notify("evolution", Msg.evolution(dataPoke.nickname))
#	poke.queue_free()
#	newPoke.queue_free()

func mountToSaveStatusPoke(poke, status) -> Dictionary:
	var lvEvo = poke.pokeStatus.levelEvolution
	var cdEvo = poke.pokeStatus.codeEvolution
	var isEvoNat = poke.pokeStatus.isEvolutionNatual
	var cd = poke.pokeStatus.code
	var isCanEvo = 0

	if(isEvoNat && lvEvo > 0):
		if(status.level >= lvEvo):
			if(cd != cdEvo):
				isCanEvo = 1
	
	var newValues = mountNewStatus(status, isCanEvo)

	refreshDataBagPoke(poke.id, newValues)
	return newValues

func mountNewStatus(status, isCanEvo) -> Dictionary:
	return {
		"hp": status.hp,
		"atk": status.atk,
		"def": status.def,
		"atkSp": status.atkSp,
		"defSp": status.defSp,
		"level": status.level,
		"isCanEvo": isCanEvo
	}

func refreshDataBagPoke(idPoke, newValues) -> void:
	pass
#	var dataPoke = GlobalPlayer.getDataPokeBagById(idPoke)
#	for key in newValues:
#		dataPoke[key] = newValues[key]

# func saveXp(idPoke: int, xp) -> void:
# 	if(xp && xp > 0):
# 		# print("[GlobalPoke] Ganho de XP ", int(xp/2))
# 		Request.setXp(idPoke, xp*7)
# 	else:
# 		print("[GlobalPoke] xp = 0")

func generatePoke(id: int, level: int): #-> Pokemon:
	var poke = getObjectPoke(id)
	
	poke.pokeStatus.level = level
	return poke.instance()

func setAttacksInPoke(poke, dataPoke) -> void:
	poke.pathMove1 = null
	poke.pathMove2 = null
	poke.pathMove3 = null
	poke.pathMove4 = null
	
	if(dataPoke.move1):
		poke.pathMove1 = getAttackDir(dataPoke.move1)
	if(dataPoke.move2):
		poke.pathMove2 = getAttackDir(dataPoke.move2)
	if(dataPoke.move3):
		poke.pathMove3 = getAttackDir(dataPoke.move3)
	if(dataPoke.move4):
		poke.pathMove4 = getAttackDir(dataPoke.move4)

func getAttackDir(atkName: String) -> String:
	return "res://Scenes/attacks/"+atkName+"/"+atkName+".tscn"

func getObjectPoke(id: int):
	return load("res://Scenes/characters/"+PokeList.getName(id)+"/"+PokeList.getName(id)+".tscn")

#func getInstancePoke(id: int):
#	var poke = load("res://Scenes/characters/"+PokeList.getName(id)+"/"+PokeList.getName(id)+".tscn")
#	return poke.instance()

func setStatusPokeBag(poke, pokeBag) -> void:
	var status = poke.pokeController.getStatus()
	status["hp"] = pokeBag.acHp
	status["acHp"] = pokeBag.acHp
	status["maxHp"] = pokeBag.hp
	status["atk"] = pokeBag.atk
	status["def"] = pokeBag.def
	status["level"] = pokeBag.level
	status["atkSp"] = pokeBag.atkSp
	status["defSp"] = pokeBag.defSp
	status["gender"] = pokeBag.gender
	status["xp"] = pokeBag.xp
	
	poke.pokeController.refreshStatusDefault(pokeBag.hp)

func saveAcHp(idPoke, acHp):
	pass
#	var dataPoke = GlobalPlayer.getDataPokeBagById(idPoke)
#	dataPoke.acHp = acHp
#	GlobalPlayer.setDataPokeBagById(idPoke, dataPoke)
#	GlobalPlayer.emitRefreshPokeProfiles()
#	Request.saveAcHp(idPoke, acHp)

func getInstancePokeById(idPoke: int) -> Node2D:
	var pName = PokeList.getName(idPoke)
	var pokeInstance = load("res://Scenes/characters/"+pName+"/"+pName+".tscn").instance()
	
	pokeInstance.id = idPoke
	return pokeInstance

