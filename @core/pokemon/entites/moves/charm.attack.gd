extends PokemonMoveAbstract
class_name CharmAttack

func _init() -> void:
  id = "charm-attack"
  code = 1
  name = "Charm"
  pwr = 20
  countdown = 1
  type = PokemonMoveAbstract.Type.SPECIAL
  atkType = PokemonType.FAIRY
