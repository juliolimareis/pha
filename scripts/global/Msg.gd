extends Node

var lg = "pt"

enum {
	LOGIN,
	PASSWORD,
	CHANGE_ATK,
	ADD_NEW_MOVE_NOTIFY,
	ADD_MOVE_PAINEL,
	NOT_ALLOWED_IN_BATTLE,
	LEVEL_UP,
	ACTION_EVOLUTION,
	CATCH,
	ADD_NEW_POKE,
	INFO_MOVE,
	TARGET_EFFECTS,
	STATUS_CONDITION,
	STATUS_CONDITION_SYNTHESIS,
	STATUS_DRAIN
}

func getMsg(msg) -> String:
	if(lg == 'pt'):
		return Pt.msg[msg]
	else:
		return Ue.msg[msg]

func replaceWorksInfoMove(infoText) -> String:
	if(lg == 'pt'):
		return infoText.replace("False", "não").replace("True", "[color=#3FE43F]sim[/color]").replace("[color=#F54F4F]0[/color]","-").replace("reduce","reduzir").replace("add","adicionar").replace("enemy","alvo").replace("attacker","atacante")
	else:
		return infoText.replace("False", "no").replace("True", "[color=#3FE43F]yes[/color]").replace("[color=#F54F4F]0[/color]","-")

#mensagem de novo pokemon
func newPoke(pokeName: String) -> String:
	return getMsg(ADD_NEW_POKE).replace("{name}", pokeName)

	#mensagem de captura
func catch(pokeName: String) -> String:
	return getMsg(CATCH).replace("{name}", pokeName)

#mensagem para o painel de notificação
func addNotifyNewMove(pName: String, mName: String) -> String:
	return getMsg(ADD_NEW_MOVE_NOTIFY).replace("{poke}", pName).replace("{move}", mName.replace("_", " "))

#mensagem para o painel de movimento
func addMove(move: String) -> String:
	return getMsg(ADD_MOVE_PAINEL).replace("{move}", move.replace("_", " "))

#mensagem de level up
func levelUp(pokeName: String, lv) -> String:
	return getMsg(LEVEL_UP).replace("{poke}", pokeName).replace("{lv}", str(lv))

#mensagem pós evolução
func evolution(pokeName: String) -> String:
	return getMsg(ACTION_EVOLUTION).replace("{poke}", pokeName)

func getInfoMove(dataMove) -> String:
	var infoText = getMsg(INFO_MOVE)
	infoText = infoText.replace("{name}", str(dataMove["name"])).replace("{type}", str(dataMove["type"])).replace("{pwr}", str(dataMove["pwr"])).replace("{aoe}", str(dataMove["aoe"])).replace("{modality}", str(dataMove["target"])).replace("{countdown}", str(dataMove["countdown"]))
	return replaceWorksInfoMove(infoText)
		
func getInfoMoveTargetEffect(percent: int, enemyEffects: int, increment: String, attr: String, target: String, time: float) -> String:
	var infoText = getMsg(TARGET_EFFECTS)
	return replaceWorksInfoMove(infoText.replace("{percent}", str(percent)).replace("{enemyEffects}", str(enemyEffects)).replace("{increment}", str(increment)).replace("{attr}", str(attr)).replace("{target}", target).replace("{seconds}", str(time)))

func getInfoMoveStatusCondition(percent: int, statusName: String, target: String) -> String:
	var infoText = getMsg(STATUS_CONDITION)
	return replaceWorksInfoMove(infoText.replace("{percent}", str(percent)).replace("{statusName}", statusName).replace("{target}", target))

func getInfoMoveDrain() -> String:
	return getMsg(STATUS_DRAIN)
