extends Node
#managerではキー入力の状態を全て管理する　アニメーションの管理は他のスクリプトで行う
#間隔の数値は要調整

#キー入力の種類　ドレミ
var keys = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C2"]

#入力状態管理変数
var now
var last_time = 0.0
var interval = 0.0 #押されなかった時間
var key_total = 0 #複数入力

#キーが押されているかどうか
var key_push = {
	"C": 0,
	"C#": 0,
	"D": 0,
	"D#": 0,
	"E": 0,
	"F": 0,
	"F#": 0,
	"G": 0,
	"G#": 0,
	"A": 0,
	"A#": 0,
	"B": 0,
	"C2": 0
} 
#キーが押されている長さ
var key_length = {
	"C": 0,
	"C#": 0,
	"D": 0,
	"D#": 0,
	"E": 0,
	"F": 0,
	"F#": 0,
	"G": 0,
	"G#": 0,
	"A": 0,
	"A#": 0,
	"B": 0,
	"C2": 0
}
#どんなふうに押されているか　0->とてもゆっくり 1->ゆっくり 2->普通 3->激しい 4->とても激しい
var key_state = {
	"C": 0,
	"C#": 0,
	"D": 0,
	"D#": 0,
	"E": 0,
	"F": 0,
	"F#": 0,
	"G": 0,
	"G#": 0,
	"A": 0,
	"A#": 0,
	"B": 0,
	"C2": 0
}

var key_sound = {
	"C": 0,
	"C#": 0,
	"D": 0,
	"D#": 0,
	"E": 0,
	"F": 0,
	"F#": 0,
	"G": 0,
	"G#": 0,
	"A": 0,
	"A#": 0,
	"B": 0,
	"C2": 0
}

func _process(delta: float) -> void:
	key_total = 0
	key_input() #どのキーが押されているか
	key_time() #どれくらいのスパンで押されているか
	for key in keys:
		key_total += key_push[key] #合計

func key_input():
	for key in keys:
		if Input.is_action_pressed(key):
			key_push[key] = 1
			#print(key+"が押されています")
		else:
			key_push[key] = 0
			key_sound[key] = 0

func key_time():
	for key in keys:
		if Input.is_action_just_pressed(key):
			now = Time.get_ticks_msec()
			interval = now - last_time
			last_time = now
			if interval > 30:
				var state: int
				if interval < 200:
					state=4
					print(key+" とても激しい")
				elif interval < 400:
					state = 3
					print(key+" 激しい")
				elif interval < 800:
					state = 2
					print(key+" 普通")
				elif interval < 1200:
					state = 1
					print(key+" ゆっくり")
				else:
					state = 0
					print(key+" とてもゆっくり")
				latest_state = state
				return
			else:
				interval = 0
	
var latest_state: int = -1
