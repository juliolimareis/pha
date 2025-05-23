extends Node2D

var direction = Vector2(0, 0)
export (int) var velocity = 180
export (int) var bonusBall = 1

onready var anim = $Anim

var shake
var pokeTarget: Pokemon
var catch = false
var escape = false
# marca a flag para dizer que essa pokeball já esta em execução de cation
# evintando que ela pegue outro poke
var isCatching = false

func _ready():
	anim.play("run")

func _process(delta) -> void:
	translate(direction * velocity * delta)

func _on_body_entered(body):
	if (body.is_in_group("poke_catch") && !isCatching):
		pokeTarget = body
		direction = Vector2(0, 0)
		anim.play("catch")
		pokeTarget.set_collision_layer_bit(7, false)
		calcCatch()
		isCatching = true

func _on_Anim_animation_finished(anim_name):
	if  anim_name == "catch":
#		pokeTarget.flashAnimationCatch(true)
		pokeTarget.visible = false
		anim.play("down")
	elif anim_name == "down":
		anim.play("wait")
		
	elif anim_name == "wait":
		if(catch):
			if(shake <= 0):
				anim.play("success")
			else:
				shake=+-1
				anim.play("wait")
		elif(!catch && shake > 0):
			shake=+-1
			anim.play("wait")
		else:
			anim.play("fail")
	#FIXME catch success
	elif anim_name == "success":
		GlobalPlayer.emitRefreshPokeProfiles()
		if(GlobalPoke.tempDataNewPokeInBag):
			GlobalPoke.saveNotifyNewPokeCatch(GlobalPoke.tempDataNewPokeInBag.nickname)
			GlobalPoke.tempDataNewPokeInBag = null
		pokeTarget.queue_free()
		queue_free()
	elif anim_name == "fail":
#		pokeTarget.flashAnimationCatch(false)
		pokeTarget.visible = true
		pokeTarget.set_collision_layer_bit(7, true)
		#TODO !* add mensagem de pokémon fugiu
		if(escape):
			queue_free()

#retorna o numero de vezes que deve verificar (wait)
func calcCatch() -> int:
	shake = 0
	var hpMax = pokeTarget.pokeStatus.statusDefault.hp
	var rate = pokeTarget.pokeStatus.catchRate
	var acHp = ((hpMax/100)*20)
	
	var a: float = ((3*hpMax - 2*acHp) * rate * bonusBall) / (3 * hpMax)
	var r: float = (pow((255/a), 0.1875))
	var b = int(65536/r)
	
	for i in 4:
		var randInt = Utils.randInt(0, 65535)
		if (b > randInt):
			shake += 1
	
	if (shake == 4):
		catch = true
		Game.savePoke(pokeTarget, true)
		shake = Utils.randInt(1, 3)
	else:
		escape = true

	return shake
