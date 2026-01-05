extends MoveAbstract
class_name CharmAttack

func _init() -> void:
  id = "charm-attack"
  code = 1
  name = "Charm"
  pwr = 20
  countdown = 1
  type = PokemonType.FAIRY
  category = MoveAbstract.Category.SPECIAL
