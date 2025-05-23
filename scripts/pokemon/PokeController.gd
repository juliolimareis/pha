class_name PokeController

var poke: Pokemon
var status # -> Json<StatusPoke>
var statusController
var effectPokeController
var cowntdown

func _init(node: Pokemon) -> void:
	poke = node
	poke.animationTree.active = true
	status = poke.pokeStatus.status
	statusController = poke.pokeStatus
	cowntdown = poke.cowntdown
	startHealthBar()
	effectPokeController = EffectPokeController.new(node)
	startLabelLv()

func startLabelLv() -> void:
	if(poke.is_in_group("poke_self")):
		poke.labelLv.text = "\nLv "+str(getValueStatus('level'))
		poke.labelLv.set("custom_colors/font_color", "#446efc")
	else:
		poke.labelLv.text = poke.pokeStatus.Name+"\nLv "+str(getValueStatus('level'))
#		if(GlobalPlayer.isBattle):
#			poke.labelLv.set("custom_colors/font_color", "#ff0000")

func setLabelLv(newLv: int) -> void:
	poke.labelLv.text = "Lv " + str(newLv)

func getStatus(): #-> status:
	return poke.pokeStatus.status

func getStatusDefault(): #-> status:
	return poke.pokeStatus.statusDefault

func setValueStatus(name: String, value) -> void:
	poke.pokeStatus.status[name] = value

func getValueStatus(name: String): # -> value
	return poke.pokeStatus.status[name]

func refreshStatusDefault(defaultHp: int) -> void:
	poke.pokeStatus.refreshStatusDefault(defaultHp)
	startHealthBar()
	
func setStatus(newStatus) -> void:
	poke.pokeStatus.status = newStatus
	status = newStatus

func startHealthBar() -> void:
	poke.healthBar.initial(getStatusDefault().hp, getStatus().hp)

func getHealthBar(): #-> status:
	return poke.healthBar

func disableCollision() -> void:
	poke.set_collision_layer_value(0, false)  
	poke.set_collision_mask_value(1, false)
	poke.z_index = -5

func enableCollision() -> void:
	poke.set_collision_layer_value(0, true)  
	poke.set_collision_mask_value(1, true)
	poke.z_index = 0

func revive(hp: int) -> void:
	enableCollision()
	poke.state = poke.MOVE
	setValueStatus('hp', hp)
	poke.healthBar.updated(hp)

func disableAllAnimConditions() -> void:
	poke.isBurn = false
	poke.isSleep = false
	poke.isPoison = false
	poke.isParalysis = false

func processStatusCondition(conditions, idsPokeAttack) -> void:
	effectPokeController.processStatusCondition(conditions, idsPokeAttack)

func processReceiverEffectAttack(effectTime, effects) -> void:
	if(poke.isLive()):
		effectPokeController.processReceiverEffectAttack(effectTime, effects)

func sendSelfEffectsAttack(attack) -> void:
	if(attack.effect):
		if(attack.effectTarget == "self" || attack.effectTarget == "both"):
			processReceiverEffectAttack(attack.effectTime, attack.selfEffects)

func recoverStatusValue(statusName: String) -> void:
	effectPokeController.recoverStatusValue(statusName)

func isAccurray() -> bool:
	if(status.accuracy < 100):
		var failure: int = int(100 - status.accuracy)
		var probabily = AttackProcess.new().getRandomInt(1, 100)
		if (probabily < failure):
			print("Accurray Erro!")
			return false
	return true

func statusPoison(isPoison) -> void:
	poke.isPoison = isPoison
	if(isPoison):
		poke.sprite.modulate = Color(0.70, 0.40, 0.94)
	else:
		poke.sprite.modulate = Color.WHITE

func cure(cure: int) -> void:
	var hp = getStatusDefault().hp
	var acHp = getValueStatus('hp')

	if(acHp > 0 && acHp != hp):
		acHp += cure
		
		if(acHp > hp):
			acHp = hp

	getHealthBar().updated(acHp)
	setValueStatus("hp", acHp)

#	if(GlobalPlayer.isSelf(poke.idPlayer)):
#		var dataPoke = GlobalPlayer.getDataPokeBagById(poke.id)
#		dataPoke.acHp = acHp
#		GlobalPlayer.emitRefreshPokeProfiles()
#		Request.saveAcHp(dataPoke.idPokemon, dataPoke.acHp)
