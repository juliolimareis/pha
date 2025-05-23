extends Node

#deprecated
func setPoke(id, body) -> void:
	Server.Put('/pokemon/'+str(id), '', body)

func updatePoke(id, jsonProps) -> void:
	Server.Put('/pokemon/'+str(id), '', jsonProps)

func setPokeChannel(id, body, channel: String) -> void:
	Server.Put('/pokemon/'+str(id), channel, body)

func setValuePoke(id, key: String, value) -> void:
	Server.Put('/pokemon/'+str(id), '', {key: value})
	
func getNotifi():
	Server.Get('/profile/notification', 'response_notifi', {})

func saveNotification():
	Server.Put('/profile/notification', 'response_notifi', Game.notifications)

func getMoveNotifi():
	Server.Get('/pokemon/moveNotifi/'+str(GlobalPlayer.getDataPokeBagByPokeSelect().idPokemon), 'response_moves_notifi_poke', {})

func saveMoveNotifi():
	Server.Put('/pokemon/moveNotifi/'+str(GlobalPlayer.getDataPokeBagByPokeSelect().idPokemon), 'response_moves_notifi_poke', Game.notificationsMove)

func saveItems():
	Server.Put('/profile/items', '', GlobalPlayer.items)

func saveAcHp(id, acHp: int):
	Server.Put('/pokemon/ac/'+str(id), '', {"acHp": acHp})

func getLearnset(code, lv):
	Server.Get('/pokemon/learnset/'+str(code)+'?level='+str(lv), 'addLearnset', {})
	
func setXp(idPoke: int, xp):
	Server.Put('/pokemon/'+str(idPoke), 'getXp', {"xp": int(xp)})

func setStatus(idPoke: int, statusJson):
	Server.Put('/pokemon/'+str(idPoke), 'lvUpResponse', statusJson)

func savePosition():
	var body = {
		"locationName": GlobalPlayer.locationName,
		"positionX": GlobalPlayer.getPosition().x,
		"positionY": GlobalPlayer.getPosition().y
	}
	Server.Put('/profile/location', '', body)

func saveEv(idPoke: int, ev):
	Server.Put('/pokemon/ev/'+str(idPoke), '', ev)

func saveNewPoke(dataNewPoke, channel: String):
	Server.Post('/profile/pokemon', channel, dataNewPoke)

func getServerData(channel: String):
	Server.Get('/server', channel, {})

func getPokeDepot(channel: String):
	Server.Get('/profile/poke/depot', channel, {})

func getPokeBag(channel: String):
	Server.Get('/profile/poke/bag', channel, {})
