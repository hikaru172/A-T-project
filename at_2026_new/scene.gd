extends TextureRect

var scenes = [0, 1]
var seasons = ["spring", "summer", "autumn", "winter"]
var times = ["morning", "noon", "evening", "night"]

var scene_index = 0   # 景色0からスタート
var season_index = 1  # summer からスタート
var time_index = 1    # noon からスタート

func _ready():
	_update_texture()

func _process(_delta):
	if Manager.latest_state == 0:
		Manager.latest_state = -1
		scene_index = (scene_index + 1) % scenes.size()
		_update_texture()
		print("景色 → " + str(scenes[scene_index]))
	if Manager.latest_state == 1:
		Manager.latest_state = -1
		season_index = (season_index + 1) % seasons.size()
		_update_texture()
		print("季節 → " + seasons[season_index])
	if Manager.latest_state == 2:
		Manager.latest_state = -1
		time_index = (time_index + 1) % times.size()
		_update_texture()
		print("時間帯 → " + times[time_index])

func _update_texture():
	var path = "res://asset/scene_" + str(scenes[scene_index]) + "_" + seasons[season_index] + "_" + times[time_index] + ".png"
	texture = load(path)
