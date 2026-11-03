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
		"log_level": SilentWolfLogLevel.ERRORS as int,
	})

func load_api_key() -> String:
	if not FileAccess.file_exists(API_KEY_PATH):
		push_error("Could not locate API key file at (%s)" % API_KEY_PATH)
		return ""
	var key = Utilities.get_text_file_content(API_KEY_PATH).strip_edges()
	print("got api key!")
	return key

func get_scores(count: int = 10):
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(count).sw_get_scores_complete
	return sw_result.scores

func get_player_name() -> String:
	GameplayEvents.broadcast("refresh_player_name")
	return player_name

func sort_scores(a, b):
	if a.score < b.score:
		return true
	return false

func filter_scores(score) -> bool:
	if score == null:
		print("Filtered null score.")
		return false
	else:
		return true
	#if !score.has("metadata"):
		#return false
	#return score.metadata.version == ProjectSettings.get_setting("application/config/version")

func get_low_scores(count: int = 1000) -> Array:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(count).sw_get_scores_complete
	var scores: Array = sw_result.scores
	
	# Simplify scores for hash consistency
	for i in range(scores.size()):
		scores[i] = {"player_name": scores[i].player_name, "score": scores[i].score}
		
	# Remove scores with duplicate names and times.
	scores = Utilities.get_unique_array_entries(scores)
	
	# Remove invalid or null scores
	scores = scores.filter(filter_scores)
	
	# sort score array from smallest to largest.
	scores.sort_custom(sort_scores)
	
	return scores

func save_score() -> void:
	print("saving score (%s: %s)" % [get_player_name(), GameTimer.timer])
	var leaderboard_name := "main"
	var metadata := {
		"version": ProjectSettings.get_setting("application/config/version"),
		"debug_build": OS.is_debug_build(),
		"platform": OS.get_version()
	}
	SilentWolf.Scores.save_score(get_player_name(), GameTimer.timer, leaderboard_name, metadata)
