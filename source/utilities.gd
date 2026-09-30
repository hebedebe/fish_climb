class_name Utilities

static func dot_separated_string(...arguments: Array) -> String:
	var string: String = ""
	for i: int in range(arguments.size()):
		if i: # not the first index
			string += "."
		string += arguments[i]
	return string

static func load_image_texture(path: String) -> ImageTexture:
	
	var loaded_image := Image.new()
	var error := loaded_image.load(path)
	
	if error != OK:
		return null

	return ImageTexture.create_from_image(loaded_image)
