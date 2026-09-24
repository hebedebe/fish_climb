class_name Utilities

static func dot_separated_string(...arguments: Array) -> String:
	var string: String = ""
	for i: int in range(arguments.size()):
		if i: # not the first index
			string += "."
		string += arguments[i]
	return string
