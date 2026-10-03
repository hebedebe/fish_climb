extends Node

enum SilentWolfLogLevel {
	ERRORS=0,
	INFO=1,
	DEBUG=2,
}

const GAME_ID = "FishClimb"
const API_KEY_PATH = "res://data/leaderboard_api_key.txt"

var player_name: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("Configuring SilentWolf")
	
	SilentWolf.configure({
		"api_key": load_api_key(),
		"game_id": GAME_ID,
		"log_level": SilentWolfLogLevel.ERRORS,
	})

	#SilentWolf.configure_scores({
		#"open_scene_on_close": "res://scenes/MainPage.tscn"
	#})

func load_api_key() -> String:
	if not FileAccess.file_exists(API_KEY_PATH):
		push_error("Could not locate API key file at (%s)" % API_KEY_PATH)
		return ""
	var key = Utilities.get_text_file_content(API_KEY_PATH).strip_edges()
	print("got api key!")
	return key

func get_scores():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	return sw_result.scores

func save_score() -> void:
	print("saving score (%s: %s)" % [player_name, GameTimer.timer])
	SilentWolf.Scores.save_score(player_name, GameTimer.timer)
