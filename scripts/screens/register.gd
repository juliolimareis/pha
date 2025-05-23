extends Control

var loginAuto = false
var isFildracos = false

var name_person: String = ""
var email: String = ""
var password: String = ""

var useSSL = false
var isLoader = false

onready var http = HTTPRequest.new()
onready var containerMessageDanger = $MessageDanger
onready var dangerMessage = $MessageDanger/Danger
onready var textButton = $NinePatchRect/VBoxContainer/LoginButton/TextButton

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func setLoading(loading: bool):
	if(loading):
		textButton.text = "Verificando...."
		isLoader = true
	else:
		textButton.text = "Cadastrar"
		isLoader = false

func _on_LoginButton_pressed():
	if(name_person && email && password):
		if(!isLoader):
			setLoading(true)
			containerMessageDanger.visible = false
#			$HTTPRequest.set_use_threads(true)
			var body: String = '{' + '\"nickname\":' + '\"' + String(name_person) + '\",' +'\"email":' + '\"' + String(email) + '\",'+ '\"passwd":' + '\"' + String(password) + '\"' + '}'
			#var headers = ["Content-Type: application/json", "Content-Length: " + str(body.length())]
			var headers = ["Content-Type: application/json"]
			var error = $HTTPRequest.request(GlobalUrl.api+'/player', headers, useSSL, HTTPClient.METHOD_POST, body)
			
			if error != OK:
				setLoading(false)
				containerMessageDanger.visible = true
				dangerMessage.text = "Requsição bloqueada."
	else:
		setLoading(false)
		containerMessageDanger.visible = true
		dangerMessage.text = getMsg400()

func _on_request_completed(result, responseCode, headers, body):
	var json = JSON.parse(body.get_string_from_utf8()).result

	if(responseCode == 201):
		containerMessageDanger.visible = false
		GlobalScene.toLogin()
	else:
		setLoading(false)
		containerMessageDanger.visible = true
		if(responseCode == 400):
			dangerMessage.text = getMsg400()
		elif(responseCode == 0):
			dangerMessage.text = "Não foi possível conectar. \n Verifique sua conexão com a internet e tente novamente."
		else:
			dangerMessage.text = getMsg400()

func getMsg400() -> String:
	return "Verifique os dados de entrada. Insira um email válido. \nSenha deve ser maior ou igual a 6 digitos \nNome deve sei igual ou maior que 4 digitos."

func startGame():
	Server.initConn()
	Server.connect("_connected", self, "_on_connected")
	
func _on_connected():
	GlobalPlayer.startGame = true
	get_tree().change_scene(GlobalScene.world)

func _on_Name_text_changed(new_text):
	name_person = new_text

func _on_Email_text_changed(new_text):
	email = new_text

func _on_Password_text_changed(new_text):
	password = new_text

func _on_toLoginButton_pressed():
	GlobalScene.toLogin()

