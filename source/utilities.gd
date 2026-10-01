class_name Utilities

static func dot_separated_string(...arguments: Array) -> String:
	var string: String = ""
	for i: int in range(arguments.size()):
		if i: # not the first index
			string += "."
		string += "%s" % arguments[i]
	return string

static func load_image_texture(path: String) -> ImageTexture:
	var loaded_image := Image.new()
	var error := loaded_image.load(path)
	
	if error != OK:
		return null

	return ImageTexture.create_from_image(loaded_image)

static func get_text_file_content(filePath) -> String:
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content
	
static func format_time(time: float) -> String:
	var minutes = floor(time / 60.0)
	var seconds = floori(time) % 60
	var milliseconds = time - floor(time)
	return "%02d:%02d.%0d" % [minutes, seconds, milliseconds*1000]

static func small_hash(string: String) -> String:
	return string.sha1_text().substr(0,6)
