extends Node2D
# garden.gd
# ・背景（空・地面）をコードで描画
# ・Managerのキー入力を受けて木・雲・草などのイラストをスポーン
#
# シーン構成:
#   Garden (Node2D) ← このスクリプトをアタッチ
#   ├── Sky    (Node2D)  ← 空背景 + 雲・太陽・蝶
#   ├── Ground (Node2D)  ← 地面背景 + 木・草・花
#   └── UI
#       └── MessageLabel (Label)  ← 省略可

# ── 画面サイズ (プロジェクト設定に合わせて変更) ──────────────────────────
const SCREEN_W := 1280.0
const SCREEN_H := 720.0
const GROUND_Y := 560.0   # 地面の上端Y座標（空と地面の境界）

# ── 各キーに対応するスポーン設定 ────────────────────────────────────────
# spawn_type : オブジェクトの種類 (draw_xxx() で描画)
# is_sky     : true なら空エリア、false なら地面エリアに配置
const KEY_SPAWN := {
	"C":  { "spawn_type": "tree_round",   "is_sky": false, "msg": "まるい木が生えた！" },
	"C#": { "spawn_type": "tree_slim",    "is_sky": false, "msg": "細い木が生えた！" },
	"D":  { "spawn_type": "cloud_big",    "is_sky": true,  "msg": "大きな雲が浮かんだ！" },
	"D#": { "spawn_type": "cloud_small",  "is_sky": true,  "msg": "ちいさな雲が浮かんだ！" },
	"E":  { "spawn_type": "grass",        "is_sky": false, "msg": "草むらが生えた！" },
	"F":  { "spawn_type": "flower_red",   "is_sky": false, "msg": "赤い花が咲いた！" },
	"F#": { "spawn_type": "flower_yellow","is_sky": false, "msg": "黄色い花が咲いた！" },
	"G":  { "spawn_type": "mushroom",     "is_sky": false, "msg": "キノコが生えた！" },
	"G#": { "spawn_type": "rock",         "is_sky": false, "msg": "岩が現れた！" },
	"A":  { "spawn_type": "bush",         "is_sky": false, "msg": "低木が生えた！" },
	"A#": { "spawn_type": "dandelion",    "is_sky": false, "msg": "たんぽぽが咲いた！" },
	"B":  { "spawn_type": "butterfly",    "is_sky": true,  "msg": "蝶が飛んできた！" },
	"C2": { "spawn_type": "sun",          "is_sky": true,  "msg": "お日様が輝いた！" },
}

# ── サイズ倍率テーブル (Manager.latest_state 0〜4 に対応) ───────────────
const SIZE_SCALE := [0.6, 0.8, 1.0, 1.3, 1.6]

@onready var sky_node:    Node2D = $Sky
@onready var ground_node: Node2D = $Ground
@onready var label_msg:   Label  = $UI/MessageLabel  # 任意。なければ削除可

func _ready() -> void:
	# ── 背景を最背面に挿入 ────────────────────────────────────────────
	var sky_bg := _SkyBackground.new()
	sky_bg.screen_w = SCREEN_W
	sky_bg.sky_height = GROUND_Y
	sky_node.add_child(sky_bg)
	sky_node.move_child(sky_bg, 0)  # 最背面

	var ground_bg := _GroundBackground.new()
	ground_bg.screen_w = SCREEN_W
	ground_bg.ground_height = SCREEN_H - GROUND_Y
	ground_bg.position = Vector2(0, GROUND_Y)
	ground_node.add_child(ground_bg)
	ground_node.move_child(ground_bg, 0)  # 最背面

func _process(_delta: float) -> void:
	for key in KEY_SPAWN.keys():
		if Input.is_action_just_pressed(key):
			_spawn(key)

func _spawn(key: String) -> void:
	var cfg: Dictionary = KEY_SPAWN[key]
	var state: int = clamp(Manager.latest_state, 0, 4)
	Manager.latest_state = -1  # リセット
	var scale_val: float = SIZE_SCALE[state]

	# 配置するノードを作成
	var node := Node2D.new()
	var drawer := _make_drawer(cfg["spawn_type"])
	node.add_child(drawer)

	# 位置を決める
	if cfg["is_sky"]:
		node.position = Vector2(
			randf_range(60, SCREEN_W - 60),
			randf_range(60, GROUND_Y - 120)
		)
		sky_node.add_child(node)
	else:
		node.position = Vector2(
			randf_range(30, SCREEN_W - 30),
			GROUND_Y
		)
		ground_node.add_child(node)

	# スケール（激しさで大きさが変わる）
	node.scale = Vector2(scale_val, scale_val)

	# ポップインアニメーション
	node.scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(node, "scale",
		Vector2(scale_val, scale_val), 0.3
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# メッセージ表示
	if label_msg:
		label_msg.text = cfg["msg"]

# ── 各タイプの描画ノードを返す ───────────────────────────────────────────
func _make_drawer(spawn_type: String) -> Node2D:
	var d := _Drawer.new()
	d.spawn_type = spawn_type
	return d

# ── インナークラス: draw() で手書き風SVGを再現 ──────────────────────────
class _Drawer extends Node2D:
	var spawn_type := ""

	func _draw() -> void:
		match spawn_type:
			"tree_round":    _draw_tree_round()
			"tree_slim":     _draw_tree_slim()
			"cloud_big":     _draw_cloud(80, 40)
			"cloud_small":   _draw_cloud(50, 26)
			"grass":         _draw_grass()
			"flower_red":    _draw_flower(Color(0.91, 0.19, 0.19), Color(1.0, 0.88, 0.0))
			"flower_yellow": _draw_flower(Color(0.96, 0.78, 0.0), Color(1.0, 0.53, 0.0))
			"mushroom":      _draw_mushroom()
			"rock":          _draw_rock()
			"bush":          _draw_bush()
			"dandelion":     _draw_dandelion()
			"butterfly":     _draw_butterfly()
			"sun":           _draw_sun()

	# ── まるい木 ──────────────────────────────────────────────────────
	func _draw_tree_round() -> void:
		var trunk := Color(0.55, 0.37, 0.17)
		var leaf1 := Color(0.35, 0.67, 0.18)
		var leaf2 := Color(0.43, 0.75, 0.25)
		draw_rect(Rect2(-8, -30, 16, 30), trunk)
		draw_circle(Vector2(0, -60), 30, leaf1)
		draw_circle(Vector2(-18, -45), 20, leaf2)
		draw_circle(Vector2(18, -45), 20, leaf2)

	# ── 細い木 ──────────────────────────────────────────────────────
	func _draw_tree_slim() -> void:
		var trunk := Color(0.55, 0.37, 0.17)
		var leaf  := Color(0.29, 0.62, 0.16)
		draw_rect(Rect2(-5, -30, 10, 30), trunk)
		# 三角形3段
		var pts1 := PackedVector2Array([Vector2(0,-90), Vector2(-22,-55), Vector2(22,-55)])
		var pts2 := PackedVector2Array([Vector2(0,-70), Vector2(-26,-35), Vector2(26,-35)])
		var pts3 := PackedVector2Array([Vector2(0,-50), Vector2(-30,-15), Vector2(30,-15)])
		draw_colored_polygon(pts1, leaf)
		draw_colored_polygon(pts2, leaf)
		draw_colored_polygon(pts3, leaf)

	# ── 雲 ────────────────────────────────────────────────────────
	func _draw_cloud(rx: float, ry: float) -> void:
		var c := Color(1, 1, 1, 0.95)
		draw_circle(Vector2(-rx * 0.4, 0),   ry,        c)
		draw_circle(Vector2(0, -ry * 0.6),   ry * 1.1,  c)
		draw_circle(Vector2(rx * 0.4, 0),    ry * 0.85, c)
		draw_circle(Vector2(0, ry * 0.3),    ry * 0.8,  c)

	# ── 草むら ──────────────────────────────────────────────────
	func _draw_grass() -> void:
		var c1 := Color(0.29, 0.67, 0.13)
		var c2 := Color(0.36, 0.75, 0.19)
		for i in range(7):
			var x := -30.0 + i * 10.0
			var h := randf_range(18, 35)
			var col := c1 if i % 2 == 0 else c2
			draw_line(Vector2(x, 0), Vector2(x + randf_range(-4,4), -h), col, 3.0, true)

	# ── 花 ────────────────────────────────────────────────────────
	func _draw_flower(petal_col: Color, center_col: Color) -> void:
		var stem := Color(0.29, 0.67, 0.13)
		draw_line(Vector2(0, 0), Vector2(0, -36), stem, 3.0, true)
		for i in range(5):
			var angle := deg_to_rad(i * 72.0)
			var p := Vector2(cos(angle), sin(angle)) * 10
			draw_circle(p + Vector2(0, -42), 8, petal_col)
		draw_circle(Vector2(0, -42), 6, center_col)

	# ── キノコ ──────────────────────────────────────────────────
	func _draw_mushroom() -> void:
		var cap   := Color(0.91, 0.19, 0.19)
		var spots := Color(1, 1, 1, 0.75)
		var stem  := Color(0.94, 0.85, 0.70)
		# 傘
		draw_circle(Vector2(0, -28), 22, cap)
		# 柄
		var pts := PackedVector2Array([
			Vector2(-10, -10), Vector2(10, -10),
			Vector2(14, 0), Vector2(-14, 0)
		])
		draw_colored_polygon(pts, stem)
		# 白点
		draw_circle(Vector2(-8, -30), 4, spots)
		draw_circle(Vector2(8, -24),  3, spots)
		draw_circle(Vector2(2, -38),  3, spots)

	# ── 岩 ────────────────────────────────────────────────────────
	func _draw_rock() -> void:
		var c1 := Color(0.67, 0.67, 0.67)
		var c2 := Color(0.75, 0.75, 0.75)
		var pts := PackedVector2Array([
			Vector2(-28, 0), Vector2(-22, -16),
			Vector2(-6, -24), Vector2(12, -20),
			Vector2(26, -8),  Vector2(28, 0)
		])
		draw_colored_polygon(pts, c1)
		var pts2 := PackedVector2Array([
			Vector2(-20, 0), Vector2(-16, -12),
			Vector2(-4, -20), Vector2(10, -16),
			Vector2(20, -6),  Vector2(20, 0)
		])
		draw_colored_polygon(pts2, c2)

	# ── 低木 ────────────────────────────────────────────────────
	func _draw_bush() -> void:
		var c1 := Color(0.36, 0.75, 0.19)
		var c2 := Color(0.43, 0.85, 0.25)
		draw_circle(Vector2(-18, -10), 16, c1)
		draw_circle(Vector2(0,   -18), 20, c2)
		draw_circle(Vector2(18,  -10), 16, c1)

	# ── たんぽぽ ──────────────────────────────────────────────
	func _draw_dandelion() -> void:
		var stem   := Color(0.29, 0.67, 0.13)
		var petal  := Color(1.0, 0.91, 0.0)
		var center := Color(1.0, 0.65, 0.0)
		draw_line(Vector2(0, 0), Vector2(0, -38), stem, 2.5, true)
		for i in range(10):
			var angle := deg_to_rad(i * 36.0)
			var tip := Vector2(cos(angle), sin(angle)) * 14 + Vector2(0, -46)
			draw_line(Vector2(0, -46), tip, petal, 2.0, true)
		draw_circle(Vector2(0, -46), 5, center)

	# ── 蝶 ────────────────────────────────────────────────────────
	func _draw_butterfly() -> void:
		var w1 := Color(0.97, 0.56, 0.94, 0.9)
		var w2 := Color(0.82, 0.38, 0.82, 0.9)
		var body_col := Color(0.29, 0.17, 0.06)
		# 上翅
		var lup := PackedVector2Array([Vector2(0,-2), Vector2(-28,-16), Vector2(-22,8)])
		var rup := PackedVector2Array([Vector2(0,-2), Vector2(28,-16),  Vector2(22,8)])
		draw_colored_polygon(lup, w1)
		draw_colored_polygon(rup, w1)
		# 下翅
		var ldo := PackedVector2Array([Vector2(0,4), Vector2(-22,10), Vector2(-14,22)])
		var rdo := PackedVector2Array([Vector2(0,4), Vector2(22,10),  Vector2(14,22)])
		draw_colored_polygon(ldo, w2)
		draw_colored_polygon(rdo, w2)
		# 胴
		draw_line(Vector2(0,-12), Vector2(0,16), body_col, 3.0, true)
		# 触角
		draw_line(Vector2(0,-12), Vector2(-8,-26), body_col, 1.5, true)
		draw_line(Vector2(0,-12), Vector2(8,-26),  body_col, 1.5, true)
		draw_circle(Vector2(-8,-26), 2.5, body_col)
		draw_circle(Vector2(8,-26),  2.5, body_col)

	# ── 太陽 ────────────────────────────────────────────────────
	func _draw_sun() -> void:
		var c  := Color(1.0, 0.88, 0.0)
		var c2 := Color(0.97, 0.75, 0.0)
		draw_circle(Vector2.ZERO, 22, c)
		for i in range(8):
			var angle := deg_to_rad(i * 45.0)
			var inner := Vector2(cos(angle), sin(angle)) * 26
			var outer := Vector2(cos(angle), sin(angle)) * 40
			draw_line(inner, outer, c2, 4.0, true)

# ════════════════════════════════════════════════════════════════════════════
# 空の背景
# ════════════════════════════════════════════════════════════════════════════
class _SkyBackground extends Node2D:
	var screen_w  := 1280.0
	var sky_height := 560.0

	func _draw() -> void:
		# ── グラデーション風の空（上：深い空色 → 下：明るい水色）──────────
		# Godotの draw_* は単色なので、細い帯を重ねてグラデーションを表現する
		var steps := 32
		for i in range(steps):
			var t    := float(i) / float(steps)
			var y    := t * sky_height
			var h    := sky_height / steps + 1.0  # 隙間が出ないよう +1
			var col  := Color(
				lerp(0.40, 0.62, t),   # R: 深青→水色
				lerp(0.62, 0.84, t),   # G
				lerp(0.90, 0.96, t)    # B
			)
			draw_rect(Rect2(0, y, screen_w, h), col)

		# ── 地平線付近のやわらかいハイライト帯 ─────────────────────────
		var horizon_col := Color(0.98, 0.92, 0.72, 0.35)
		draw_rect(Rect2(0, sky_height - 60, screen_w, 60), horizon_col)

		# ── 遠景：うっすらした丘のシルエット ────────────────────────────
		var hill_col := Color(0.55, 0.78, 0.38, 0.55)
		# 左の丘
		var pts_l := PackedVector2Array([
			Vector2(0, sky_height),
			Vector2(0, sky_height - 80),
			Vector2(120, sky_height - 130),
			Vector2(300, sky_height - 90),
			Vector2(460, sky_height - 110),
			Vector2(600, sky_height),
		])
		draw_colored_polygon(pts_l, hill_col)
		# 右の丘
		var pts_r := PackedVector2Array([
			Vector2(screen_w, sky_height),
			Vector2(screen_w, sky_height - 70),
			Vector2(screen_w - 100, sky_height - 120),
			Vector2(screen_w - 300, sky_height - 85),
			Vector2(screen_w - 500, sky_height - 105),
			Vector2(screen_w - 640, sky_height),
		])
		draw_colored_polygon(pts_r, hill_col)

# ════════════════════════════════════════════════════════════════════════════
# 地面の背景
# ════════════════════════════════════════════════════════════════════════════
class _GroundBackground extends Node2D:
	var screen_w      := 1280.0
	var ground_height := 160.0

	func _draw() -> void:
		# ── ベースの地面色（上：明るい緑 → 下：濃い緑）────────────────
		var steps := 16
		for i in range(steps):
			var t   := float(i) / float(steps)
			var y   := t * ground_height
			var h   := ground_height / steps + 1.0
			var col := Color(
				lerp(0.36, 0.24, t),
				lerp(0.72, 0.50, t),
				lerp(0.22, 0.14, t)
			)
			draw_rect(Rect2(0, y, screen_w, h), col)

		# ── 上端の草ライン ───────────────────────────────────────────
		var grass_dark  := Color(0.28, 0.60, 0.16)
		var grass_light := Color(0.42, 0.78, 0.22)
		# ベース帯
		draw_rect(Rect2(0, 0, screen_w, 14), grass_dark)
		# ギザギザの草っぽいライン（短い縦棒を並べる）
		var blade_count := int(screen_w / 8)
		for i in range(blade_count):
			var x    := i * 8.0 + randf_range(-2, 2)
			var bh   := randf_range(8, 22)
			var col  := grass_light if i % 3 != 0 else grass_dark
			draw_line(Vector2(x, 0), Vector2(x + randf_range(-2,2), -bh), col, 2.5, true)

		# ── 土の質感（まばらな暗い点）────────────────────────────────
		var dirt := Color(0.20, 0.42, 0.10, 0.4)
		for i in range(60):
			var x := randf_range(0, screen_w)
			var y := randf_range(18, ground_height)
			draw_circle(Vector2(x, y), randf_range(2, 5), dirt)
