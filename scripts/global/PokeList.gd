extends Node

func getName(code: int) -> String:
	if(code == 0):
		return pokeList[str(1)]
	return pokeList[str(code)]

func getColor(id: int) -> String:
	if (id):
		return colorsType[id]
	else:
		return colorsType[0]

func getType(id: int) -> String:
	if (id):
		return types[id]
	else:
		return types[0]

# FIXME: movido para GlobalPoke
func getPokeById(idPoke: int) -> Node2D:
	var pName = PokeList.getName(idPoke)
	
	return load("res://Scenes/characters/"+pName+"/"+pName+".tscn").instance()

# {code, minLv-MaxLv, porcent, MinAmount-MaxAmount}
# {19, 1-2, 90, 1}, {10, 1-2, 10, 1}
# FIXME: movido para GlobalPoke
func getRangePokeGenerateBattle(strRange: String, maxAmountPoke: int) -> Array:
	var result = []
	var arrRange: Array = Utils.split(strRange, "|")

	for pRange in arrRange:
		var arrValues: Array = Utils.split(pRange, ",")
		var arrAmount = Utils.splitInt(arrValues[3], "-")
		var amount = arrAmount[0]
		if(arrAmount.size() > 1):
			amount = Utils.randInt(arrAmount[0], arrAmount[1])
		
		for amt in amount:
			if(Utils.prob(int(arrValues[2]))):
				var poke = getPokeById(int(arrValues[0]))
				var arrLv = Utils.splitInt(arrValues[1], "-")
				poke.isMob = true
				poke.level = arrLv[0]
				if(arrLv.size() > 1):
					poke.level = Utils.randInt(arrLv[0], arrLv[1])
				
				if maxAmountPoke > 0:
					if result.size() != maxAmountPoke:
						result.push_back(poke)
				else:
					result.push_back(poke)
	return result

var pokeList = {
	#gen 1
	"1":"Bulbasaur",
	"2":"Ivysaur",
	"3":"Venusaur",
	"4":"Charmander",
	"5":"Charmeleon",
	"6":"Charizard",
	"7":"Squirtle",
	"8":"Wartortle",
	"9":"Blastoise",
	"10":"Caterpie",
	"11":"Metapod",
	"12":"Butterfree",
	"13":"Weedle",
	"14":"Kakuna",
	"15":"Beedrill",
	"16":"Pidgey",
	"17":"Pidgeotto",
	"18":"Pidgeot",
	"19":"Rattata",
	"20":"Raticate",
	"21":"Spearow",
	"22":"Fearow",
	"23":"Ekans",
	"24":"Arbok",
	"27": "Sandshrew",
	"28":"Sandslash",
	"36":"Clefable",
	"54":"Psyduck",
	"55":"Golduck",
	"68":"Machamp",
	"94":"Gengar",
	"123":"Scyther",
	"129":"Magikarp",
	"130":"Gyarados",
	"136":"Flareon",
	"131":"Lapras",
	"145":"Zapdos",
	"197":"Umbreon",
#gen 2
	"243":"Raikou",
	"260":"Swampert",
#gen 3
	"373":"Salamence",
	"376":"Metagross",
}

var colorsType = [
	"#8c888c", # 
	"#a8a878", # normal
	"#f08030", # fire
	"#c03028", # fighting
	"#6890f0", # water
	"#a890f0", # flying
	"#78c850", # grass
	
	"#a040a0", # poison
	"#f8d030", # electric
	"#e0c068", # ground
	"#f85888", # psychic
	"#b8a038", # rock
	"#98d8d8", # ice
	
	"#a8b820", # bug
	"#7038f8", # dragon
	"#705898", # ghost
	"#705848", # dark
	"#b8b8d0", # steel
	"#ee99ac" # fairy
]

var colorsStatusCondition = {
	"burn": "#f08030",
	"sleep": "#78c850",
	"poison": "#a040a0",
	"paralysis": "#f8d030",
	"confusion": "#f85888",
	"freeze": "#98d8d8",
	"seed": "#78c850",
	"immune": "#a8a878",
}

var types = ["Status", "Normal", "Fire", "Fighting", "Water", "Flying", "Grass", "Poison", "Electric", "Ground", "Psychic", "Rock", "Ice", "Bug", "Dragon", "Ghost", "Dark", "Steel", "Fairy"]
