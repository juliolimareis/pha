extends Control

onready var bagContainer: GridContainer = $TextureRect/GridContainerBag
onready var depotContainer: GridContainer = $TextureRect/ScrollContainerDepot/GridContainer
onready var buttonConfirm: Button = $TextureRect/Button

var pokesDepot = []

func _ready():
	buttonConfirm.visible = false
	ServerResponse.connectChannel('getPokesDepot', self, "_on_refresh_menu_depot")
	# atualiza os arrays caso tenha clique no itemDepot
	DepotController.connect("updateDepot", self, "_on_update_depot")
	# Request.getPokeDepot("getPokesDepot")

func _process(delta):
	if(DepotController.pokesDepotBag != GlobalPlayer.dataPokesBag):
		buttonConfirm.visible = true
	else:
		buttonConfirm.visible = false

func _on_update_depot():
	addItems()

func addItems():
	addPokesBagContainer()
	addPokesDepotContainer()

func _on_refresh_menu_depot(response):
	DepotController.pokesDepot = response
	DepotController.pokesDepotBag = GlobalPlayer.dataPokesBag.duplicate()
	$Loading.visible = false
	addItems()

# adicionar os pokes na grid bag
func addPokesBagContainer() -> void:
	Utils.removeAllChildren(bagContainer)

	var pokes = DepotController.pokesDepotBag
		
	for i in range(pokes.size()):
		var depotItem = Utils.getPokeDepot().instance()
		depotItem.get_node('Miniature').setIndex(i)
		depotItem.get_node('Miniature').setPokeData(pokes[i])
		depotItem.get_node('Miniature').isBag = true
		bagContainer.add_child(depotItem)
		
func addPokesDepotContainer() -> void:
	Utils.removeAllChildren(depotContainer)

	for node in depotContainer.get_children():
		node.queue_free()

	var pokes = DepotController.pokesDepot

	for i in range(pokes.size()):
		var depotItem = Utils.getPokeDepot().instance()
		depotItem.get_node('Miniature').setIndex(i)
		depotItem.get_node('Miniature').setPokeData(pokes[i])
		depotItem.get_node('Miniature').isBag = false
		depotContainer.add_child(depotItem)

func _on_Button_pressed():
	DepotController.updatePokesDepot()
