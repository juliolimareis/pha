class_name PokemonFactory

static func build(code: int) -> PokemonAbstract:
	match code:
		1:
			return Bulbasaur.new()
		_:
			push_error("Pokemon code {code} not found".format({ "code": code }))
			return null
