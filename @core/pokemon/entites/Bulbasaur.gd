class_name Bulbasaur
extends PokemonAbstract

func _init() -> void:
  code = 1
  name = "Bulbasaur"
	
  atk = 49
  sp_atk = 64
  def = 49
  sp_def = 65
  genderBase = 50
  hp = 45
  speed = 80
  catchRate = 45
  
  levelingRate = PokemonLevel.LevelingRate.MEDIUM_SLOW
  type = [PokemonBaseAbstract.Type.GRASS, PokemonBaseAbstract.Type.POISON]

  catchRate = 45

  atk_ev = 0
  atkSp_ev = 1
  def_ev = 0
  defSp_ev = 0
  exp_ev = 64
  hp_ev = 0
  speed_ev = 0
