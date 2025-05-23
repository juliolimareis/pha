extends Control

export (String, "", "juliolimareis", "mgabriel", "slyfer", "draco", "barb", "cad_2") var account
export (String) var customAccount = ""
export (bool) var validVersion = true
export (bool) var autoLogin = true

var login: String = ""
var password: String = ""

var useSSL = false
var isLoader = false

onready var http = HTTPRequest.new()
onready var containerMessageDanger = $MessageDanger
onready var dangerMessage = $MessageDanger/Danger
onready var textButton = $NinePatchRect/VBoxContainer/LoginButton/TextButton

func _ready():
#	Game.isValidVersion = validVersion
#	if Game.isVersion:
	
	if(account || customAccount):
		addAutoInfoLogin()
	if(autoLogin):
		_on_LoginButton_pressed()
#	else:
#		setDangerMessage("Versão descontinuada.", true)

func addAutoInfoLogin():
	if(customAccount):
		login = str(customAccount, "@gmail.com")
	else:
		login = str(account, "@gmail.com")
	password = "123456"

func setLoading(loading: bool):
	if(loading):
		textButton.text = "Verificando...."
		isLoader = true
	else:
		textButton.text = "Entrar"
		isLoader = false

func _on_LoginButton_pressed():
	GlobalServer.setServerMessage("")
	if(login && password):
		if(!isLoader):
			setLoading(true)
			containerMessageDanger.visible = false
			GlobalServer.startConnect(login, password)
	else:
		setLoading(false)
		containerMessageDanger.visible = true
		dangerMessage.text = "Informações incompletas."

func _on_Login_text_changed(value):
	login = value

func _on_Password_text_changed(value):
	password = value

func _process(delta):
	delta = delta
	if(GlobalServer.serverMessage):
		setLoading(false)
		containerMessageDanger.visible = true
		dangerMessage.text = GlobalServer.serverMessage

# ##################### deprecated
	
func _on_request_completed(result, responseCode, headers, body):
	headers = headers
	result = result
	var json = JSON.parse(body.get_string_from_utf8()).result

	if(responseCode == 200):
		# GlobalPlayer.token = json.token
		GlobalUrl.TOKEN = json.token
		containerMessageDanger.visible = false
		startGame()
	else:
		setLoading(false)
		containerMessageDanger.visible = true
		if(responseCode == 403 || responseCode == 400):
			dangerMessage.text = "Credenciais inválidas."
		elif(responseCode == 0):
			dangerMessage.text = "Não foi possível conectar. \n Verifique sua conexão com a internet e tente novamente."
		else:
			dangerMessage.text = "Não foi possível fazer login. Tente novamente mais tarde."

func startGame():
	Server.connect("_connected", self, "_on_connected")
	Server.initConn()
	if Server.ws.get_connection_status() == 0:
		setLoading(false)
		setDangerMessage("Não foi possível conectar. Tente novamente mais tarde.", true)
	
func _on_connected():
	GlobalPlayer.startGame = true
	get_tree().change_scene(GlobalScene.startGame)

func _on_RegisterButton_pressed():
	GlobalScene.toRegister()
	
func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			_on_LoginButton_pressed()

func setDangerMessage(text: String, enable: bool):
	dangerMessage.text = text
	containerMessageDanger.visible = enable
