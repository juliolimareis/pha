class_name ClientController

var selfId: int
var pokes = []
var oldPokePlayer #: JSON<pokeStatus>
var pokePlayer: Pokemon

func setStatePlayer(poke: Pokemon, infoPlayer) -> void:

	if(selfId != infoPlayer.id):
		poke.position.x = infoPlayer.position.x
		poke.position.y = infoPlayer.position.y
 
		poke.pokeController.setStatus(infoPlayer.status)

	poke.pokeController.getHealthBar().updated(infoPlayer.status.hp)

	if(infoPlayer.status.hp > 0):
		
		if(selfId != infoPlayer.id):
			processConditions(poke, infoPlayer)
			
			if(infoPlayer.isNetworkDamage):
				poke.flashAnimation()
		
		if(!infoPlayer.isSleep):
			poke.input_vector.x = infoPlayer.input_vector.x
			poke.input_vector.y = infoPlayer.input_vector.y

			poke.directionPoke.x = infoPlayer.directionPoke.x
			poke.directionPoke.y = infoPlayer.directionPoke.y

			poke.move(Vector2(infoPlayer.velocity.x, infoPlayer.velocity.y))

		if(infoPlayer.isAttack):
			poke.momentAttack = infoPlayer.momentAttack
			if infoPlayer.momentAttack == 1:
				poke.atk1()
			elif infoPlayer.momentAttack == 2:
				poke.atk2()
			elif infoPlayer.momentAttack == 3:
				poke.atk3()
			elif infoPlayer.momentAttack == 4:
				poke.atk4()
	else:
		poke.input_vector = Vector2.ZERO

func processConditions(poke: Pokemon, infoPlayer) -> void:
	poke.isBurn = infoPlayer.isBurn
	poke.isSleep = infoPlayer.isSleep
	poke.isFreeze = infoPlayer.isFreeze
	poke.isPoison = infoPlayer.isPoison
	poke.isParalysis = infoPlayer.isParalysis
	poke.isConfusion = infoPlayer.isConfusion

	if(poke.isSleep):
		if(poke.state != poke.SLEEP):
			poke.startSleep()
	else:
		if(poke.state == poke.SLEEP):
			poke.state = poke.MOVE

func getInfoPokePlayer(): # -> JSON
	return getInfo(pokePlayer)

func isRefreshPlayer() -> bool:
	if(pokePlayer != null && oldPokePlayer != null):
		if(getInfo(pokePlayer).player.hash != oldPokePlayer.player.hash):
			return true
	return false

func addPoke(poke: Node2D, infoPlayer) -> void:
	poke.id = infoPlayer.id
	pokes.push_back(poke)
	#poke.setStatus(infoPlayer.status) 
	setStatePlayer(poke, infoPlayer)

func setSelfPoke(poke: Node2D) -> void:
	setPokePlayer(poke)
	pokes.push_back(pokePlayer)

func setVisiblePokePlayer(visible: bool) -> void:
	pokePlayer.visible = visible

func setId(idPoke: int) -> void:
	selfId = idPoke
	pokePlayer.id = idPoke

func setPokePlayer(poke: Node2D) -> void:
	pokePlayer = poke

func refreshPokeJson() -> void:
	oldPokePlayer = getInfo(pokePlayer)

func setPosition(poke: Pokemon, infoPlayer) -> void:
	poke.position.x = infoPlayer.position.x
	poke.position.y = infoPlayer.position.y

	poke.input_vector.x = infoPlayer.input_vector.x
	poke.input_vector.y = infoPlayer.input_vector.y

	poke.directionPoke.x = infoPlayer.directionPoke.x
	poke.directionPoke.y = infoPlayer.directionPoke.y

	poke.pokeController.setStatus(infoPlayer.status)
	poke.pokeController.startHealthBar()

func getInfo(poke: Pokemon): # -> JSON
	var info = {
		"player":{
			"id": poke.id,
			"name": poke.pokeStatus.name,
			"status": poke.pokeStatus.status,

			"isAttack": poke.isAttack,
			"momentAttack": poke.momentAttack,
			"isNetworkDamage": poke.isNetworkDamage,

			"isBurn": poke.isBurn,
			"isSleep": poke.isSleep,
			"isPoison": poke.isPoison,
			"isFreeze": poke.isFreeze,
			"isParalysis": poke.isParalysis,
			"isConfusion": poke.isConfusion,

			"velocity": {
				"x": poke.velocity.x,
				"y": poke.velocity.y
			},
			"directionPoke":{
				"x": poke.directionPoke.x,
				"y": poke.directionPoke.y
			},
			"input_vector": {
				"x": poke.input_vector.x,
				"y": poke.input_vector.y
			},
			"position": {
				"x": poke.position.x,
				"y": poke.position.y
			},
		}
	}
	info["player"]["hash"] = hash(info["player"])
	return info

enum {
	MOVE,
	ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4
}
