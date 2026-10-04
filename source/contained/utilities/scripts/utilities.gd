class_name Utilities

static func dot_separated_string(...arguments: Array) -> String:
	var string: String = ""
	for i: int in range(arguments.size()):
		if i: # not the first index
			string += "."
		string += "%s" % arguments[i]
	return string

static func load_image_texture(path: String, generate_mipmaps: bool = true) -> ImageTexture:
	if not FileAccess.file_exists(path):
		push_error("File at path '%s' does not exist" % path)
		return null
	
	var loaded_image := Image.new()
	var error := loaded_image.load(path)
	
	if error != OK:
		return null
	
	if generate_mipmaps:
		if loaded_image.generate_mipmaps() != OK:
			push_error("Failed to generate pattern mipmaps")

	return ImageTexture.create_from_image(loaded_image)

static func get_text_file_content(filePath) -> String:
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

static func get_byte_file_content(filePath) -> PackedByteArray:
	var data = FileAccess.get_file_as_bytes(filePath)
	return data
	
static func format_time(time: float) -> String:
	var minutes = floor(time / 60.0)
	var seconds = floori(time) % 60
	var milliseconds = time - floor(time)
	return "%02d:%02d.%0d" % [minutes, seconds, milliseconds*1000]

static func small_hash(string: String) -> String:
	return string.sha1_text().substr(0,5)

## use to replace testing loads/preloads (where possible) to mitigate errors in export
static func editor_load(path: String, 
		allow_in_editor: bool = true, allow_embedded: bool = true) -> Variant:
	if ((Engine.is_editor_hint() and allow_in_editor) or 
			(Engine.is_embedded_in_editor() and allow_embedded)):
		return load(path)
	return generate_empty_resource()

static var empty_resource_count: int = 0
static func generate_empty_resource() -> Resource:
	empty_resource_count+=1
	var resource := Resource.new()
	resource.resource_name = "Empty Resource #%s" % empty_resource_count
	print("Generated empty resource (%s)" % resource)
	return resource

static func is_web_export() -> bool:
	return OS.has_feature("web")
	
	
