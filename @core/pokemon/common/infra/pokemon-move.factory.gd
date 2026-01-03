class_name PokemonMoveFactory

static func build(code: int) -> PokemonMoveAbstract:
	match code:
		1:
			return CharmAttack.new()
		_:
			push_error("Attack code ${code} not found")
			return null
