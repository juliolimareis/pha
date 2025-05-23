extends Node2D

var pokeName: String
var level: int
var idPoke: int
var pokeCode: int
var hpMax: int
var hpValue: int
var xpMax: int
var xpValue: int
var isCanEvo: int

onready var lvPoke = $Level
onready var labelPoke = $Name
onready var healthBarHp = $Bars/Hp
onready var healthBarXp = $Bars/Xp
onready var pokeball = $Images/pokeball
onready var sprProfile = $Images/profile
onready var pokeballOpen = $Images/pokeball_open

func _ready():
	$Control.connect("mouse_left_click", self, "_on_change_main_poke")
	$Evolution.connect("mouse_left_click", self, "_on_evolution")
	initial()

func _process(delta):
	delta = delta
	$Bars/HpLabel.text = str(healthBarHp.value)+"/"+str(healthBarHp.max_value)

func initial():
	labelPoke.text = pokeName
	healthBarHp.max_value = hpMax
	
	healthBarHp.value = hpValue
	healthBarXp.max_value = xpMax
	
	healthBarXp.value = xpValue
	lvPoke.text = "Lv "+str(level)
	setPhoto()
#	var dataPoke = GlobalPlayer.getDataPokeBagById(idPoke)
	
	if(GlobalPlayer.isBattle):
		if(idPoke == GlobalPlayer.idPokeSelect):
			$Control.visible = false
			pokeballOpen.visible = true
	else:
		if(idPoke == GlobalPlayer.idMainPoke):
			pokeball.visible = true
			$Control.visible = false
	
	if(isCanEvo == 1 && !GlobalPlayer.isBattle):
		$Evolution.visible = true

	if(GlobalPlayer.isPokeDeadById(idPoke)):
		$Images/profile.set_self_modulate("ff8f8f") 

func _on_change_main_poke():
	if(!GlobalPlayer.isBattle):
		GlobalPlayer.changeMainPoke(idPoke)

func _on_evolution():
	GlobalPoke.evolution(idPoke)

func setName(_name):
	pokeName = _name

func setHp(hp):
	hpValue = hp

func setXp(xp):
	xpValue = xp

func setPhoto():
	var pName = PokeList.getName(pokeCode)
	sprProfile.set_texture(Utils.getImgPokeProfile(pName))
