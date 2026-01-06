extends Node2D

class_name moveStatus

@export var pwr := 0
@export_enum("Physical", "Special") var atkType: String
@export_enum("Normal", "Fire", "Fighting", "Water", "Flying", "Grass", "Poison", "Electric", "Ground", "Psychic", "Rock", "Ice", "Bug", "Dragon", "Ghost", "Dark", "Steel", "Fairy") var type: String
@export var countdown := 3
@export_enum("range", "sight", "close") var target: String
@export var effect := false
@export var effectAccuracy := 100
@export_enum("self", "enemy", "both") var effectTarget: String
@export var effectTime := 2.0
@export var damageBack := 0

# Percentage chance to apply status conditions to enemy
@export var enemyStatusCondition := {
	"burn": 0,
	"sleep": 0,
	"paralysis": 0,
	"poison": 0,
	"confusion": 0,
	"freeze": 0,
	"synthesis": 0,
	"seed": 0,
	"rainDance": 0,
	"dragonDance": 0,
	"sunnyDay": 0
}

# Percentage chance to apply status conditions to self
@export var selfStatusCondition := {
	"burn": 0,
	"sleep": 0,
	"paralysis": 0,
	"poison": 0,
	"confusion": 0,
	"freeze": 0,
	"synthesis": 0,
	"seed": 0,
	"rainDance": 0,
	"dragonDance": 0,
	"sunnyDay": 0
}

@export var enemyEffects := {
	"hp": {"reduce": 0, "add": 0},
	"atk": {"reduce": 0, "add": 0},
	"def": {"reduce": 0, "add": 0},
	"atkSp": {"reduce": 0, "add": 0},
	"defSp": {"reduce": 0, "add": 0},
	"speed": {"reduce": 0, "add": 0},
	"accuracy": {"reduce": 0, "add": 0}
}

@export var selfEffects := {
	"hp": {"reduce": 0, "add": 0},
	"atk": {"reduce": 0, "add": 0},
	"def": {"reduce": 0, "add": 0},
	"atkSp": {"reduce": 0, "add": 0},
	"defSp": {"reduce": 0, "add": 0},
	"speed": {"reduce": 0, "add": 0},
	"accuracy": {"reduce": 0, "add": 0}
}

@export var unaffected := {
	"all": false,
	"damage": false,
	"status": false,
	"effects": false,
	"burn": false,
	"sleep": false,
	"paralysis": false,
	"poison": false,
	"confusion": false,
	"freeze": false,
	"seed": false,
	"synthesis": false
}

#deve ser preenchida pelo pokemon atacante
var pokemonAttack = 0
var pokemonAttackSp = 0
var instanceIdPokemon
# nome do grupo do ataque
var groupName = ""
# tratativa para ataques com fihished apenas acertar um alvo
var isDamage = true
#objeto contendo os ids do jogador e pokemon atacante
var idsPokeAttack = {"idPlayer": 0, "idPokemon": 0, "instanceIdPokemon": 0}
#instance_id do pokemon atacante
var instanceIdPokeAttack: int = 0

# var poke: Node2D

# func setStatusAttack(atk, atkSp) -> void:
# 	pokemonAttack = atk
# 	pokemonAttackSp = atkSp
	
# func _on_Fire_1_body_entered(body) -> void:
# 	# TODO verificar ataque no amigo
	
# #	if GlobalPlayer.isRaid:
# #		if body.is_in_group("player_self") || body.is_in_group("player_friend"):
# #			if (groupName != "attack_mob"):
# #				return
# #	if body.is_in_group("player_mob"):
# #		if groupName == "attack_mob":
# #			return
	
# 	# tratativa para ataques com finished apenas acertar um alvo
# 	if get_parent().animationFinished:
# 		if instanceIdPokeAttack == body.get_instance_id():
# 			return
			
# 	if(poke != null && isDamage):
# 		#verifica ataque repetido
# 		if(!receiverIsAttack(poke)):
# 			if(pwr != null && pwr > 0):
# 				processDamageAttack(poke)
# 			if(effect):
# 				processEffectAttack(poke)
		
# 		# tratativa para ataques com fihished apenas acertar um alvo
# 		if get_parent().animationFinished:
# 			isDamage = false

# func processEffectAttack(poke: Pokemon) -> void:
# 	poke.pokeController.processStatusCondition(enemyStatusCondition, idsPokeAttack)
	
# 	if(effectAccuracy < 100):
# 		var failure: int = int(100 - effectAccuracy)
# 		if(AttackProcess.new().getRandomInt(1, 100) > failure):
# 			poke.pokeController.processReceiverEffectAttack(effectTime, enemyEffects)
# 			# if checkUnaffected():
# 			# 	poke.startUnaffected(unaffected, effectTime)
# 		else:
# 			print("Effect attack failed!")
# 	else:
# 		poke.pokeController.processReceiverEffectAttack(effectTime, enemyEffects)

# func processDamageAttack(poke) -> void:
# 	poke._on_Timer_timeout_sleep()
# 	sendDamage(poke)

# func getPokemonBody(body) -> Pokemon:
# 	if(body.get_parent().has_method("isPoke")):
# 		return body.get_parent()
# 	elif(body.has_method("isPoke")):
# 		return body
# 	else: 
# 		return null
# #TODO
# func sendDamage(poke: Pokemon) -> void:
# 	poke.setAttackReceiver(self.get_instance_id())
# 	var damage = poke.pokeController.statusController.processDamage(getMove())
# 	if get_parent().attackName == "giga_drain" && damage > 0:
# 		var div = Utils.randInt(2, 8)
# 		poke.emitCure(idsPokeAttack, int(damage/div))


# #verifica se o pokémon já recebeu este ataque
# func receiverIsAttack(poke) -> bool:
# 	return verifyReceiverAttack(poke)

# #verifica se esse ataque já acertou este alvo
# func verifyReceiverAttack(poke) -> bool:
# 	if(poke.has_method("getAttackReceiver")):
# 		if(instanceIdPokemon == poke.get_instance_id()):
# 			return true
# 		var receiver = poke.getAttackReceiver()
# 		if(receiver != null):
# 			if(receiver == self.get_instance_id()):
# 				return true
# 			else:
# 				poke.setAttackReceiver(null)
# 	return false

# func getTarget() -> String: 
# 	return target

# func getMove(): # JSON<generic>
# 	return {
# 		"pwr": pwr,
# 		"type": type,
# 		"atkType": atkType,
# 		"pokemonAttack": pokemonAttack,
# 		"pokemonAttackSp": pokemonAttackSp,
# 		"target": target
# 	}

# func setInstanceIdPokemon(id):
# 	instanceIdPokemon = id
# 	idsPokeAttack.instanceIdPokemon = id

# func checkUnaffected() -> bool:
# 	for key in unaffected:
# 		if(unaffected[key]):
# 			return true
# 	return false
