extends Node2D

#local para onde vai trocar
export (String) var path = ""
# nome do local, que será salvo do banco
export (String) var locationName = ""
# imediatamente ou precisa apertar botão de ação 
export (bool) var immediate = false
# mapa temposrário (mapas temp não são salvos no banco)
export (bool) var isMapTemp = false

export (bool) var exitToWorld = false

export (bool) var isBattle = false
export (bool) var isEntryArea = false
export (bool) var isGenetateMob = false
export (bool) var isAreaCatch = false
export (bool) var isAutoConnect = false
export (bool) var isDepot = false

export (bool) var isGrass = false

export (String) var nodeInstancePlayer = ""

export (bool) var isPvp = false

# verifica qual a porcentagem de ativar a ação
export (int) var activationPercent = 100

export (int) var maxAmountPoke = 0
#export (int) var minLevelPoke = 3
#export (int) var maxLevelPoke = 4

export (bool) var isCureAll = false

# code, level(range), porcent, quantidade(range)
export (String) var pokes = "10, 1-2, 90, 1-2"

export (int) var maxItem = 1

# codeItem, porcent, quantidade(range)
export (String) var items = "10, 90, 1-2"

var isArea = false

func _ready():
#	if isGrass:
#		isBattle = true
#		isAreaCatch = true
#		isGenetateMob = true
##		GlobalPlayer.inWorld = false
##		path = GlobalScene.battleGrass
#
	if isAutoConnect:
		connect("body_entered", self, "_on_body_entered")
		connect("body_exited", self, "_on_body_exited")
#
##func _input(event: InputEvent) -> void:
##	if(isArea):
##		if(event.is_action_pressed("action") && !GlobalPlayer.isChat):
##			if isDepot:
##				DepotController.setIsOpenDepot(true)
##			else:
##				changeScene()
#
func _on_body_entered(body):
	if body.is_in_group("player_self") || body.is_in_group("player"):
		if (isEntryArea):
			body.isEntryArea = true
#
#		if isDepot:
#			activeArea()
#			return
#
#		# caso seja batalha ou pvp verificar se jogador tem pokemon vivo
#		if(isBattle || isPvp):
#			if(!Game.isExistPokeAlive()):
#				return
#
#		if(exitToWorld):
#			path = GlobalScene.world
#			locationName = "world"
#
##		if(Utils.prob(activationPercent) && path):
##			activeArea()
##			if(immediate):
##				changeScene()
#
#func activeArea():
#	isArea = true
#	GlobalPlayer.emitAreaBattle(true)
#
func _on_body_exited(body):
	pass
#	if body.is_in_group("player_self"):
#		isArea = false
#		GlobalPlayer.emitAreaBattle(false)
#
#func changeScene():
#	if(path || isGrass):
#		if GlobalPlayer.hasPokeBag():
#			Game.emitExitBattle(!isBattle)
#
#		GlobalPlayer.isBattle = isBattle
#		Game.isAreaCatch = isAreaCatch
#
#		if isBattle:
#			GlobalPlayer.inWorld = false
#
#		if(isGenetateMob):
#			if(Game.isExistPokeAlive()):
#				Game.pokesMobBattle = PokeList.getRangePokeGenerateBattle(pokes, maxAmountPoke)
#
#		setLocationName()
#
#		if exitToWorld:
#			GlobalPlayer.inWorld = true
#			GlobalPlayer.isBattle = false
#
#		if GlobalPlayer.inWorld:
#			Server.emitChannel("removePoke", {"idPlayer": GlobalPlayer.idPlayer}, true)
#
#		GlobalScene.changeScene(path)
#
#func setLocationName():
#	if(isMapTemp):
#		GlobalPlayer.locationNameTemp = locationName
#	GlobalPlayer.locationName = locationName
