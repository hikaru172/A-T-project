extends Node

# ノード名と音名の対応表
const NOTE_NODES := {
	"C": "audio_C",
	"C#": "audio_C#",
	"D": "audio_D",
	"D#": "audio_D#",
	"E": "audio_E",
	"F": "audio_F",
	"F#": "audio_F#",
	"G": "audio_G",
	"G#": "audio_G#",
	"A": "audio_A",
	"A#": "audio_A#",
	"B": "audio_B",
	"C2": "audio_C2",
}

func _process(_delta: float) -> void:
	for note in NOTE_NODES:
		if Manager.key_push[note] == 1 && Manager.key_sound[note] == 0:
			get_node(NOTE_NODES[note]).play()
			Manager.key_sound[note] = 1
