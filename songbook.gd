extends Control

var db
var song_list
var current_song

func _ready():
	db = open_database("res://songs.db")
	create_table()
	initialize_songs()
	show_song_list()

func open_database(path):
	var database = SQLite.new()
	if database.open(path) == OK:
		print("Database opened successfully")
		return database
	else:
		print("Error opening database")
		return null

func create_table():
	db.exec("CREATE TABLE IF NOT EXISTS songs (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, tab TEXT)")

func initialize_songs():
	var songs = [
		("Song 1", "Tab 1"),
		("Song 2", "Tab 2")
		# Добавьте еще песни по вашему желанию
	]
	
	for song in songs:
		db.exec("INSERT INTO songs (title, tab) VALUES (?, ?)", [song[0], song[1]])

func show_song_list():
	song_list = db.query("SELECT * FROM songs")
	var list_items = []
	for row in song_list:
		list_items.append(row["title"])
	$List.items = list_items

func _on_List_item_selected(index):
	if song_list:
		var selected_song = song_list[index]
		current_song = selected_song
		$.text = selected_song["tab"]
	else:TabText
		print("No songs available")

func _on_SaveButton_pressed():
	if current_song:
		db.exec("UPDATE songs SET tab = ? WHERE id = ?", [$TabText.text, current_song["id"]])
		print("Tab updated successfully")
	else:
		print("No song selected")

func _on_DeleteButton_pressed():
	if current_song:
		db.exec("DELETE FROM songs WHERE id = ?", [current_song["id"]])
		print("Song deleted successfully")
		current_song = null
		$TabText.text = ""
		show_song_list()
	else:
		print("No song selected")
