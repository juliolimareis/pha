extends Node

# func isFileExist(dir: String) -> bool:
# 	var directory = Directory.new();
# 	if directory.file_exists(dir):
# 		return true;
# 	return false;

func getMoveInstance(moveName):
	return load("res://Scenes/attacks/"+moveName+"/"+moveName+".tscn").instance() 

func getTime() -> String:
	return String("time.hour")+":"+String("time.minute")+":"+String("time.second")

func getIconDir(iconName) -> String:
	if iconName == "poke":
		return "res://img/icons/icon_poke.png"
	return "res://img/icons/icon_not_found.png"

func getIcon(iconName):
	return load(getIconDir(iconName))

func getMoveIcon(moveName: String):
	var dir = "res://Scenes/attacks/{move}/{move}_icon.png"
	var newDir = dir.replace("{move}", moveName)
	if load(newDir):
		return load(newDir)
	else:
		return getNotFoundImg()

func getImgPokeProfile(pokeName: String):
	var dir = "res://img/profile/{name}.{exten}"
	var newDir = dir.replace("{name}", pokeName).replace("{exten}", "png")
	if load(newDir):
		return load(newDir) 
#	newDir = newDir.replace("png", "webp")
#	if isFileExist(newDir): 
#		return load(newDir)
	else:
		return getNotFoundImg()

#procura a imagens nos formatos webp e png
func getImgItem(name: String):
	var dir = "res://img/items/{name}.{exten}"
	var newDir = dir.replace("{name}", name).replace("{exten}", "png")
	if load(newDir):
		return load(newDir)
	newDir = newDir.replace("png", "webp")
	if load(newDir): 
		return load(newDir)
	else:
		return getNotFoundImg()

func getNotFoundImg():
	return load("res://img/icons/icon_not_found.png")

func getPokeMiniature(pokeName: String):
	return load("res://img/miniatures/{miniature}.webp".replace("{miniature}", pokeName))

func getPokeDepot():
	return load("res://Scenes/layouts/DepotItem.tscn")

# Transforma string em array
func split(string: String, separator: String) -> Array:
	var value = ""
	var result = []
	
	for c in string:
		if(c == separator):
			result.push_back(value)
			value = ""
		else:
			value += c

	result.push_back(value)
	return result
	
# Transforma string em array convertendo valores em int
func splitInt(string: String, separator: String) -> Array:
	var value = ""
	var result = []
	var resultInt = []
	
	for c in string:
		if(c == separator):
			result.push_back(value)
			value = ""
		else:
			value += c

	result.push_back(value)
	
	for v in result:
		resultInt.push_back(int(v))
	
	return resultInt

func randInt(init: int, end: int) -> int:
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return rand.randi_range(init, end)

func prob(prob: int) -> bool:
	var calc = randInt(1, 100)
	
	if(prob >= (100 - calc)):
		return true
	return false

# cria um objeto timer com 1 loop
func timer(time: float, target: Object, callBack: String):
	var timer: Timer = Timer.new()
	
	# timer.connect("timeout", target, callBack)
	timer.one_shot = true
	timer.set_wait_time(time)
	add_child(timer)
	timer.start()
	
func removeAllChildren(node: Node):
	for child in node.get_children():
		child.queue_free()
