extends Node

func _process(delta:float)->void:
	if Manager.key_push["C"] == 1 && Manager.key_sound["C"] == 0:
		$audio_C.play()
		Manager.key_sound["C"] = 1
	
	if Manager.key_push["D"] == 1 && Manager.key_sound["D"] == 0:
		$audio_D.play()
		Manager.key_sound["D"] = 1
	
	if Manager.key_push["E"] == 1 && Manager.key_sound["E"] == 0:
		$audio_E.play()
		Manager.key_sound["E"] = 1
	
	if Manager.key_push["F"] == 1 && Manager.key_sound["F"] == 0:
		$audio_F.play()
		Manager.key_sound["F"] = 1
	
	if Manager.key_push["G"] == 1 && Manager.key_sound["G"] == 0:
		$audio_G.play()
		Manager.key_sound["G"] = 1
	
	if Manager.key_push["A"] == 1 && Manager.key_sound["A"] == 0:
		$audio_A.play()
		Manager.key_sound["A"] = 1
	
	if Manager.key_push["B"] == 1 && Manager.key_sound["B"] == 0:
		$audio_B.play()
		Manager.key_sound["B"] = 1
