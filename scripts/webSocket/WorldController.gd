class_name WorldController

var players = {}
var oldPokePlayer # -> JSON<playerStatus>
var _player: Player

func setStatePlayer(player: Player, infoPlayer) -> void:
	player.normalizedInput()
	
	if(GlobalPlayer.idPlayer != infoPlayer.id):
		player.setInputVector(Vector2(infoPlayer.input_vector.x, infoPlayer.input_vector.y))
	
	player.move(Vector2(infoPlayer.velocity.x, infoPlayer.velocity.y))

func setDataPlayer(dataPlayer) -> void:
	GlobalPlayer.setDataPlayer(dataPlayer)

func isRefreshPlayer() -> bool:
	if(_player != null && oldPokePlayer != null):
		if(getInfoPlayer().player.hash != oldPokePlayer.player.hash):
			return true
	return false

func addPlayer(player: Player, infoPlayer) -> void:
	player.id = infoPlayer.id
	players[str(infoPlayer.id)] = player
	player.isPlayer = false
	player.enableCamera(false)
	player.setNickname(infoPlayer.nickname, false)
	setStatePlayer(player, infoPlayer)

func setSelfPlayer(player: Player) -> void:
	setPlayer(player)
	# player.id = GlobalPlayer.idPlayer
	# player.setNickname(GlobalPlayer.nickname)
	player.isNetwork = true
	players[str(player.id)] = player
	# player.position = GlobalPlayer.playerPosition

func setVisiblePlayer(visible: bool) -> void:
	_player.visible = visible

func setPlayer(player: Node2D) -> void:
	_player = player

func refreshPokeJson() -> void:
	oldPokePlayer = getInfoPlayer()

func setPosition(player: Player, infoPlayer) -> void:
	player.position.x = infoPlayer.position.x
	player.position.y = infoPlayer.position.y

	player.input_vector.x = infoPlayer.input_vector.x
	player.input_vector.y = infoPlayer.input_vector.y

func getInfoPlayer(): # -> JSON
	var info = {
		"player":{
			"id": GlobalPlayer.idPlayer,

			"locationName": GlobalPlayer.locationName,
			"personName": GlobalPlayer.personName,
			"nickname": GlobalPlayer.nickname,

			"velocity": {
				"x": _player.velocity.x,
				"y": _player.velocity.y
			},
			
			"input_vector": {
				"x": _player.input_vector.x,
				"y": _player.input_vector.y
			},
			"position": {
				"x": _player.position.x,
				"y": _player.position.y
			},
			"save_position": {
				"x": GlobalPlayer.playerPosition.x,
				"y": GlobalPlayer.playerPosition.y
			},
		}
	}
	info["player"]["hash"] = hash(info["player"])
	return info
