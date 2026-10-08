class_name LeaderboardContainer extends VBoxContainer


func _ready() -> void:
	generate_entry_loop()

func generate_entry_loop() -> void:
	generate_entries()
	await get_tree().create_timer(10).timeout
	generate_entry_loop()

func clear_entries() -> void:
	for child in get_children():
		child.queue_free()

func generate_entries() -> void:
	var scores = await LeaderboardManager.get_low_scores()
	clear_entries()
	for score in scores:
		add_entry(score.player_name, score.score)

func add_entry(entry_name, entry_score) -> void:
	var leaderboard_entry := LeaderboardEntry.new()
	leaderboard_entry.entry_name = entry_name
	leaderboard_entry.entry_value = Utilities.format_time(entry_score)
	add_child(leaderboard_entry)
