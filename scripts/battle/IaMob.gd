extends Node2D

# Owner pegar o node pai
# call_deferred() execução de função
#
class_name IaMob

var thisPoke = get_parent()

var pokesPlayers 
var defaultPathNodeEnemies: String = "/root/Battle/players"

var target 
var countForAtk = 0
var isDefaultEnemies = true

var distance = 85

#FIXME isMob script
func _ready():
	# verifica se tem foi configurado o path de node para inimigos no poke
	# caso não esteja pegar o caminho default /root/Battle/players 
	if thisPoke.pathNodeEnemies:
		isDefaultEnemies = false
	
	pokesPlayers = getNodeEnemies()
	
	if thisPoke.isMob:
		if(pokesPlayers.size() > 0):
			target = pokesPlayers[0]

func getNodeEnemies() -> Array:
	if isDefaultEnemies && get_node(defaultPathNodeEnemies).get_children():
		return get_node(defaultPathNodeEnemies).get_children()
	if get_node(thisPoke.pathNodeEnemies):
		return get_node(thisPoke.pathNodeEnemies).get_children()
	return []

# retorna a posição do target
func getTarget():
	var arrPokes = getNodeEnemies()
	
	if !thisPoke.isBoss:
		return arrPokes[0]
	
	for poke in arrPokes:
		if Game.idPlayerBossTarget == poke.idPlayer:
			return poke
	return null

func _process(delta):
	delta = delta
	if thisPoke.isBoss:
		if Game.idPlayerBossTarget != GlobalPlayer.idPlayer:
			return
	else:
		if thisPoke.isSleep:
			return

	countForAtk += 1
	pokesPlayers = getNodeEnemies()
	
	if(pokesPlayers.size() > 0):
		target = getTarget()

		if(thisPoke.isMob && target != null && is_instance_valid(target) && target.isLive() && thisPoke.isLive()):
			action(delta)
		else:
			thisPoke.input_vector = Vector2.ZERO
	
	if(countForAtk == 30):
		countForAtk = 0

func action(delta):
	delta = delta
	var isMove = false
	var targetPosition = target.position
	var direction = (targetPosition - thisPoke.position).normalized()

	if(calcDistance() >= distance):
		move(direction)
		isMove = true

	if countForAtk == 30:
		var atk = Utils.randInt(1, 4)
		if atk == 1:
			thisPoke.atk1()
		elif atk == 2:
			thisPoke.atk2()
		elif atk == 3:
			thisPoke.atk3()
		elif atk == 4:
			thisPoke.atk4()

	if(isMove):
		thisPoke.input_vector = direction
	else:
		thisPoke.input_vector = Vector2.ZERO
	thisPoke.directionPoke = direction

func move(direction):
	thisPoke.move_and_slide(direction * 45)

func calcDistance():
	return thisPoke.position.distance_to(target.position)
