extends Node2D

var times = []
var timesStatus = []
var skillTree: = [true, true, true, true] 

func startSkillCountdown(numberAttack, time) -> void:
	var posAtk = numberAttack - 1
	if(skillTree[posAtk]):
		var timer = Timer.new()
		times.push_back(timer)
		var pos = (times.size() - 1)
		skillTree[posAtk] = false
		add_child(times[pos])
		times[pos].connect("timeout", self, "_on_Timer_timeout", [mountParams(timer, posAtk)])
		#print(self.get_instance_id())
		times[pos].one_shot = true
		times[pos].set_wait_time(float(time))
		times[pos].start()

		if get_parent().is_in_group("player_self"):
			GlobalTime.start('moves', str(numberAttack))
#			Game.emitMoveCountdown(str(numberAtack), time)
		# print("ataque: "+String(numberAtack)+" em cowntdown!")

#params = { "timer": Timer(), "posAtack": int }
func _on_Timer_timeout(params):
	skillTree[params.posAtack] = true
	var index: int = timesStatus.find(params.timer)
	if(index != -1):
		times.remove(index)
		if get_parent().is_in_group("player_self"):
			GlobalTime.stop('moves', str(params.posAtack))

func mountParams(timer, posAttack):
	return { "timer": timer, "posAtack": posAttack }

func verifyStatusChanged(statusName: String) -> bool:
	for ts in timesStatus:
		if(ts.name == statusName):
			return true
	return false

func setStatusChanged(statusName: String, time: float):
	if(!verifyStatusChanged(statusName)):
		var timer = Timer.new()
		add_child(timer)
		# timer.connect("timeout", self, "_on_Timer_timeout_status", [{"name": statusName}])
		timer.one_shot = true
		timer.set_wait_time(float(time))
		timer.start()
		timesStatus.push_back({"name": statusName, "timer": timer})
		
func _on_Timer_timeout_status(params):
	for ts in timesStatus:
		if(ts.name == params.name):
			var index: int = timesStatus.find(ts)
			if(index != -1):
				timesStatus.remove(index)
			get_parent().pokeController.recoverStatusValue(params.name)
