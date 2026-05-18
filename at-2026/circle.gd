extends Node2D

#円の半径
var r = {
	"C": 0,
	"D": 0,
	"E": 0,
	"F": 0,
	"G": 0,
	"A": 0,
	"B": 0
} 

#円の位置
var pos = {
	"C": Vector2(0,0),
	"D": Vector2(0,0),
	"E": Vector2(0,0),
	"F": Vector2(0,0),
	"G": Vector2(0,0),
	"A": Vector2(0,0),
	"B": Vector2(0,0)
} 

var circle_r
var circle_pos

func _ready():
	#node2dの位置
	position = get_viewport_rect().size/2
	print(position)
	#for i in range(0,10) :
	#	circle_r[i] = 0 #????????
	#	circle_pos[i] = Vector2(0,0)

func _process(delta:float)->void:
	#押してる間大きくなる、離すと小さくなる
	for key in Manager.keys:
		if Input.is_action_just_pressed(key):
			pos[key].x = randi_range(-576,576)
			pos[key].y = randi_range(-324,324)
		
		if Manager.key_push[key] == 1:
			if r[key] == 500:
				r[key] = 500
			else :
				r[key] += 7
		else :
			if r[key] <= 0:
				r[key] = 0
			else :
				r[key] -= 3
	
	queue_redraw()

func _draw():
	for key in Manager.keys:
		draw_circle(pos[key],r[key],Color8(255,255,255,150))
