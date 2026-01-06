class_name MoveFactory

static func build(code: int) -> MoveAbstract:
	match code:
		1:
			return CharmMove.new()
		2:
			return BiteMove.new()
		_:
			push_error("Move code ${code} not found")
			return null
