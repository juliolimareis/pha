class_name MoveFactory

static func build(code: int) -> MoveAbstract:
	match code:
		1:
			return CharmAttack.new()
		_:
			push_error("Attack code ${code} not found")
			return null
