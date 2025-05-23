extends Node2D

onready var slot = $slot
onready var sprMove = $move
onready var bkpModulate = slot.modulate
onready var bkpSelfModulate = slot.self_modulate
onready var bkpSprModulate = sprMove.modulate
onready var bkpSprMoveModulate = sprMove.self_modulate
#onready var info = $Info

export (String) var keyName = ""
export (String) var keyPos = ""

onready var key = $Key
var keyTime = 'moves'
var seconds
#var maxTime
var moveType
var infoMove = {}

func _ready():
#	$Info/RichTextLabel.bbcode_text = Msg.getMsg(Msg.INFO_MOVE)

	$Info.visible = false
	key.text = keyName
	$Control.connect("mouse_hover", self, "_on_hover")
	Time.getTimer(keyTime, keyPos).connect("timeout", self, "_on_verify_countdown")
	$Control.connect("mouse_left_click", self, "_on_click")
	Game.connect("move_countdown", self, "_on_start_countdown")

func _on_verify_countdown():
	if(seconds == 1):
#		seconds = maxTime
		Time.stop(keyTime, keyPos)
		countTime()
		enableCountdown(false)
	else:
		seconds -= 1
		countTime()

func _on_click():
	if Game.changeMove:
		var dataMove = Game.changeMove
		var dataPokeMain = GlobalPlayer.getDataPokeBag(0)
		var idPoke = dataPokeMain.idPokemon
		if(idPoke == dataMove.idPokemon):
			if(!GlobalPoke.verifyMoveExistInPoke(dataMove.moveName)):
				setMove(dataMove.moveName)
				var posName = "move"+keyPos
#				var pokeData = GlobalPlayer.getDataPokeBagById(idPoke)
				dataPokeMain[posName] = dataMove.moveName
				Request.setPoke(dataPokeMain.idPokemon, {posName: dataMove.moveName})
				Game.addAlertTemp("movimento "+dataMove.moveName+"foi adicionado.")
			else:
				Game.addAlertTemp("Movimento já se encontra no pokémon")
		else:
			Game.addAlertTemp("Este Movimento não pertence a esse pokémon")

func _on_hover(isHover):
	if isHover:
		$Info.visible = true
		setTextInfoAtk()
	else:
		$Info.visible = false

func _on_start_countdown(pos, maxTime):
	if pos == keyPos:
		seconds = maxTime
		countTime()
		enableCountdown(true)

func setMove(moveName):
	key.text = keyName
	var move = Utils.getMoveInstance(moveName)
	
	if(move):
		# inserindo informações do ataque
		move.isInfo = true
		moveType = move.type
		# var colorType = PokeList.colorsType[move.get_node('status').type]
		infoMove['name'] = "[color="+PokeList.getColor(moveType)+"]"+move.name+"[/color]"
		infoMove['aoe'] = !move.animationFinished
		add_child(move)
		setInfoMove(move.get_node('status'))
		move.queue_free()
		
		sprMove.set_texture(Utils.getMoveIcon(moveName))
		$Info/moveIcon.set_texture(Utils.getMoveIcon(moveName))
		resetModulates()
		seconds = 1
		setTextInfoAtk()

func enableCountdown(value: bool):
	if(value):
		slot.modulate = "#9affffff"
		slot.self_modulate = "#444343"
		sprMove.modulate = "#858585"
		sprMove.self_modulate = "#858585"
	else:
		resetModulates()
	$Time.visible = value

#restaura as configurações do slot
func resetSlot():
	slot.self_modulate = bkpSelfModulate
	slot.modulate = bkpModulate
	sprMove.modulate = bkpSprModulate
	sprMove.self_modulate = bkpSprMoveModulate
	seconds = 1
	sprMove.set_texture(null)

func resetModulates():
	slot.self_modulate = PokeList.getColor(moveType)
	slot.modulate = "#ffffff"
	sprMove.modulate = "#ffffff"
	sprMove.self_modulate = "#ffffff"

func countTime():
	$Time.text = str(seconds)

func setInfoMove(statusMove: Node2D):
	infoMove['pwr'] = statusMove.pwr
	infoMove['type'] = "[color="+PokeList.getColor(moveType)+"]"+PokeList.getType(statusMove.type)+"[/color]"
	infoMove['countdown'] = statusMove.countdown
	infoMove['target'] = statusMove.target

	infoMove['effect'] = statusMove.effect
	infoMove['effectAccuracy'] = statusMove.effectAccuracy
	infoMove['effectTarget'] = statusMove.effectTarget
	infoMove['effectTime'] = statusMove.effectTime

	infoMove['enemyEffects'] = statusMove.enemyEffects
	infoMove['selfEffects'] = statusMove.selfEffects

	infoMove['enemyStatusCondition'] = statusMove.enemyStatusCondition
	infoMove['selfStatusCondition'] = statusMove.selfStatusCondition

# FIXME Monta a descrição do ataque
func setTextInfoAtk():
	if !infoMove:
		return
	
	$Info/RichTextLabel.bbcode_text = Msg.getInfoMove(infoMove)
	var desc = ""
	if(infoMove.effect):
		for attr in infoMove.enemyEffects:
			if (infoMove.enemyEffects[attr].reduce > 0):
				desc += Msg.getInfoMoveTargetEffect(infoMove.effectAccuracy, infoMove.enemyEffects[attr].reduce, "reduce", attr, "enemy", infoMove.effectTime)
			if (infoMove.enemyEffects[attr].add > 0):
				desc += Msg.getInfoMoveTargetEffect(infoMove.effectAccuracy, infoMove.enemyEffects[attr].add, "add", attr, "enemy", infoMove.effectTime)

		for attr in infoMove.selfEffects:
			if (infoMove.selfEffects[attr].reduce > 0):
				desc += Msg.getInfoMoveTargetEffect(infoMove.effectAccuracy, infoMove.selfEffects[attr].reduce, "reduce", attr, "attacker", infoMove.effectTime)
			if (infoMove.selfEffects[attr].add > 0):
				desc += Msg.getInfoMoveTargetEffect(infoMove.effectAccuracy, infoMove.selfEffects[attr].add, "add", attr, "attacker", infoMove.effectTime)

		for attr in infoMove.enemyStatusCondition:
			if (infoMove.enemyStatusCondition.has(attr) && infoMove.enemyStatusCondition[attr] > 0):
				desc += Msg.getInfoMoveStatusCondition(infoMove.enemyStatusCondition[attr], "[color="+PokeList.colorsStatusCondition[attr]+"]"+attr+"[/color]", "enemy")
			if (infoMove.selfStatusCondition.has(attr) && infoMove.selfStatusCondition[attr] > 0):
				desc += Msg.getInfoMoveStatusCondition(infoMove.selfStatusCondition[attr], attr, "attacker")
				if attr == "synthesis":
					desc = Msg.getInfoMoveSynthesis()
		
	if infoMove['name'] == "[color=#78c850]Giga Drain[/color]":
		desc = Msg.getInfoMoveDrain()

	$Info/RichTextLabel2.bbcode_text = desc
