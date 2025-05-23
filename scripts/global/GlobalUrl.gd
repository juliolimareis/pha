extends Node

#deprecated
var apiAuth
#deorecated
var worldSocket

var SERVER
var API_AUTH
const SERVER_PORT = 8888

var TOKEN

enum {
	DEV,
	HMG,
	PROD
}

const connection_name = DEV

const DEV_SERVER = {
	"apiAuth": "http://localhost:8088",
	"server": "127.0.0.1",
}
const QAS_SERVER = {
	"apiAuth": "http://164.90.143.97:8088",
	"server": "ws://164.90.143.97:9001"
}
const PROD_SERVER = {
	"apiAuth": "https://xyyiup.conteige.cloud",
	"server": "ws://aifmxw.conteige.cloud"
}

func _init():
	match connection_name:
		DEV:
			Game.version = "DEV-"+Game.version
			setConfig(DEV_SERVER)
		HMG:
			Game.version = "HMG-"+Game.version
			setConfig(QAS_SERVER)
		PROD:
			setConfig(PROD_SERVER)
	
func setConfig(config) -> void:
	apiAuth = config.apiAuth
	worldSocket = config.server
	SERVER = config.server
	API_AUTH = config.apiAuth


