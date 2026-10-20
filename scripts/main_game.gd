extends Node2D



const save_path = "user://userdata.save"

@onready var tree: TextureButton = $CanvasLayer/Tree

var score = 0



signal score_changed


func save_data():
	var data = {
		"score": score
	}
	var file = FileAccess.open(save_path , FileAccess.WRITE)
	file.store_var(data)
	file.close()



func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path , FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			score = data.get("score" , 0)
	else:
		save_data()









func _ready():
	load_data()
	tree.pivot_offset = tree.size / 2
	$CanvasLayer/Score.text = str(score)







func _on_tree_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(tree , "scale" , Vector2(.9 , .9), .1)



func _on_tree_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(tree , "scale" , Vector2(1 , 1), .1)
	score += 1
	$CanvasLayer/Score.text = str(score)
	emit_signal("score_changed")
	save_data()





func _on_save_upd_timeout():
	emit_signal("score_changed")
	$CanvasLayer/Score.text = str(score)
	save_data()
