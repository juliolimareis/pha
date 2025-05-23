extends Camera2D

onready var moves = $Moves
onready var items = $Items
onready var actions = $Actions

func _ready():
	GlobalPlayer.connect("refresh_poke_profiles", self, "_on_setPokesProfile")
	GlobalPlayer.connect("change_poke", self, "_on_change_poke")
	GlobalPlayer.connect("change_main_poke", self, "setMoves")
#	GlobalPlayer.connect("change_action_slot", self, "setActions")
	GlobalPlayer.connect("area_battle", self, "_on_area_battle")
	Game.connect("exit_battle", self, "_on_exit_battle")
	
	Game.connect("add_alert", self, "_on_enable_alert")
	Game.connect("add_alert_temp", self, "_on_enable_alert_temp")
	
	_on_setPokesProfile()
	if(GlobalPlayer.hasPokeBag()):
		setMoves()
	setActions()

func _on_enable_alert(alert):
	if alert:
		$Alert.visible = true
		$Alert/Label.text = alert
	else:
		$Alert.visible = false

func _on_exit_battle(exit):
		_on_change_poke(exit)

func _on_change_poke(dataPoke):
	dataPoke = dataPoke
	setMoves()
	_on_setPokesProfile()

func _on_disable_alert():
	_on_enable_alert(false)

func _on_enable_alert_temp(alert, time):
	_on_enable_alert(alert)
	Utils.timer(time, self, "_on_disable_alert")

# TODO setPokesProfile
func _on_setPokesProfile():
	removeProfiles()
	GlobalPlayer.configNodeProfilePoke()
	var i = 1

	for perf in GlobalPlayer.pokeProfiles:
		get_node("ProfilePokes/p"+str(i)).add_child(perf)
		i += 1

func removeProfiles():
	for i in 6:
		if(get_node("ProfilePokes/p"+str(i+1)).get_children().size() > 0):
			for node in get_node("ProfilePokes/p"+str(i+1)).get_children():
				node.queue_free()
#			get_node("ProfilePokes/p"+str(i+1)).get_children()[0].queue_free()

# adiciona os movimentos no painel
# adiciona de acorcom com o pokémon selecionado
func setMoves():
	var dPoke = GlobalPlayer.getDataPokeBagByPokeSelect()
	for i in range(4):
		if(dPoke["move"+str(i+1)]):
			moves.get_node("move"+str(i+1)).setMove(dPoke["move"+str(i+1)])
		else:
			moves.get_node("move"+str(i+1)).resetSlot()

func setActions():
	var _items = GlobalPlayer.getItems()
	for item in _items:
		if(item.idPosition):
			items.get_node("SlotAction"+str(item.idPosition)).setAction(item)

func setAlertScreen(value: bool):
	$"alert_screen".visible = value
	
func _on_area_battle(enable):
	setAlertScreen(enable)

func _process(delta):
	delta = delta
	$Depot.visible = DepotController.isOpenDepot
