# Classe responsável por guardar os objetos de tempo do jogador
# countdowns
extends Node

var times: Dictionary = {
	"actions": {
		"1": {
			"timer": Timer.new(),
			"isInstance": false # para verificar se já foi instanciado
		},
		"2": {
			"timer": Timer.new(),
			"isInstance": false
		},
		"3": {
			"timer": Timer.new(),
			"isInstance": false
		},
		"4": {
			"timer": Timer.new(),
			"isInstance": false
		},
	},
	"moves": {
		"1": {
			"timer": Timer.new(),
			"isInstance": false # para verificar se já foi instanciado
		},
		"2": {
			"timer": Timer.new(),
			"isInstance": false
		},
		"3": {
			"timer": Timer.new(),
			"isInstance": false
		},
		"4": {
			"timer": Timer.new(),
			"isInstance": false
		},
	},
	"battle":{
		"switch":{
			"timer": Timer.new(),
			"isInstance": false,
			"cowntdown": 30
		}
	},
	"message":{
		"chat":{
			"timer": Timer.new(),
			"isInstance": false,
		}
	}
}

# func getMaxTime(timeKey: String, key: String):
# instanceTimer(timeKey, key)
# 	return times[timeKey][key].time

func getTimer(timeKey: String, key: String):
	instanceTimer(timeKey, key)
	return times[timeKey][key].timer

# Bug: verifica se está em execução retorna null
# func isStart(timeKey: String, key: String) -> bool:
# 	if times[timeKey][key].timer.is_stopped():
# 		return false
# 	else:
# 		return true

func resetAllMoves():
	for i in times['moves'].keys().size():
		stop('moves', str(i+1))

func isMoveInCountdown(movePosition: String) -> bool:
	instanceTimer('movies', movePosition)
	return times['moves'][movePosition].timer.is_stopped()

# inicia a contagem
func start(timeKey: String, key: String) -> void:
	instanceTimer(timeKey, key)
	times[timeKey][key].timer.start()

func stop(timeKey: String, key: String) -> void:
	instanceTimer(timeKey, key)
	times[timeKey][key].timer.stop()

# garante que este timer seja instanciado
# caso não esteja, ele instancia, caso esteja não faz nada
func instanceTimer(timeKey: String, key: String) -> void:
	if(!times[timeKey][key].isInstance):
		add_child(times[timeKey][key].timer)
		times[timeKey][key].isInstance = true
		times[timeKey][key].timer.set_wait_time(1)
