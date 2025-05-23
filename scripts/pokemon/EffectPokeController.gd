class_name EffectPokeController

var poke: Node2D
var status # -> Json<StatusPoke>
var statusController: Node2D

func _init(node: Node2D):
	poke = node
	poke.animationTree.active = true
	status = poke.pokeStatus.status
	statusController = poke.pokeStatus

func processReceiverEffectAttack(effectTime, effects) -> void:
	for key in effects:
		# tratar hp
		if(key != "hp"):
			#BUG
			if(effects[key]["reduce"] > 0):
				status[key] = getEffectPercentageValue(true, status[key], effects[key]["reduce"], effectTime, key)
				# print("("+status["name"]+") "+"Status "+key+" foi reduzido de "+ String(statusController.getStatusDefault()[key]) + " para " + String(status[key]))
			elif(effects[key]["add"] > 0):
				status[key] = getEffectPercentageValue(false, status[key], effects[key]["add"], effectTime, key)
				# print("("+status["name"]+") "+"Status "+key+" foi reduzido de "+ String(statusController.getStatusDefault()[key]) + " para " + String(status[key]))

func processStatusCondition(conditions, idsPokeAttack) -> void:
	if poke.checkUnaffectedValue("all") || poke.checkUnaffectedValue("effects"):
		return 

	for key in conditions:
		if(conditions[key] > 0):
			var failure: int = int(100 - conditions[key])
			if(AttackProcess.new().getRandomInt(1, 100) > failure):
				poke.startStatusCondition(key, idsPokeAttack)
			else:
				print("Failure condition: ", key)

func getEffectPercentageValue(reduce: bool, valueStatus: int, percentEffect: int, effectTime: float, statusName: String) -> int:
	if(statusName == "speed"):
		setTempSpeed(calcPorcentageValue(reduce, poke.MAX_SPEED, percentEffect))
	setTempStatus(statusName, effectTime)
	return calcPorcentageValue(reduce, valueStatus, percentEffect)
	
func setTempStatus(statusName: String, time: float):
	poke.cowntdown.setStatusChanged(statusName, time)

func calcPorcentageValue(reduce: bool, valueStatus: int, percentEffect: int) -> int:
	if(percentEffect > 0):
		var porc: float = (float(percentEffect)/float(100))
		var value: float = porc*float(valueStatus)
		if(reduce):
			return int(float(valueStatus) - value)
		else:
			return int(float(valueStatus) + value)
	return valueStatus

func setTempSpeed(tempValue: int):
	poke.MAX_SPEED = tempValue

func recoverStatusValue(statusName: String):
	if(statusName == "speed"):
		poke.MAX_SPEED = poke.max_speed_default
	statusController.recoverStatusValue(statusName)
