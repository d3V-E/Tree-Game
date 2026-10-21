extends Node2D



const save_path = "user://userdata.save"

@onready var tree: TextureButton = $CanvasLayer/Tree
@onready var convertlog : TextureButton = $CanvasLayer/Stats/Log
@onready var closeconvert : TextureButton = $"CanvasLayer/Convert/Close Convert"
@onready var convertconfirm: TextureButton = $"CanvasLayer/Convert/Convert Confirm"
@onready var convertdg: Sprite2D = $CanvasLayer/Convert
@onready var sun: Sprite2D = $CanvasLayer/Stats/Sunny
@onready var rain: Sprite2D = $CanvasLayer/Stats/Rain
@onready var cloud: Sprite2D = $CanvasLayer/Stats/Cloudy
@onready var shopopen: TextureButton = $CanvasLayer/Shop



var score = 0
var wood = 0
var weather = "Nothing"
var weathermulti = 1.0

var rarities = {"Cloudy" : 1000,
				"Sunny" : 500,
				"Rain" : 250}

var rng = RandomNumberGenerator.new()

func get_weather():
	rng.randomize()
	
	var sum = 0
	
	for n in rarities:
		sum += rarities[n]
		
	var item = rng.randi_range(0 , sum)
	
	for n in rarities:
		if item <= rarities[n]:
			return n
		item -= rarities[n]



signal score_changed
signal wood_changed


func save_data():
	var data = {
		"score": score,
		"wood": wood
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
			wood = data.get("wood" , 0)
	else:
		save_data()









func _ready():
	load_data()
	tree.pivot_offset = tree.size / 2
	convertlog.pivot_offset = convertlog.size / 2
	closeconvert.pivot_offset = closeconvert.size / 2
	convertconfirm.pivot_offset = convertconfirm.size / 2
	shopopen.pivot_offset = shopopen.size / 2
	$CanvasLayer/Score.text = str(score)
	$"CanvasLayer/Stats/Log Count".text = str(wood)
	hconverttree()
	weatherupd()




func sconverttree():
	convertdg.visible = true
	$CanvasLayer/Convert/Info.text = "SCORE = " + str(score) + " and LOGS = " + str(wood) + "\nWeather = " + str(weather) + " , Multiplier = " + str(weathermulti)



func hconverttree():
	convertdg.visible = false




func _on_tree_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(tree , "scale" , Vector2(.9 , .9), .1)



func _on_tree_button_up():
	if convertdg.visible == false:
		var tween = get_tree().create_tween()
		tween.tween_property(tree , "scale" , Vector2(1 , 1), .1)
		score += 1
		$CanvasLayer/Score.text = str(score)
		emit_signal("score_changed")
		save_data()
	else:
		pass





func _on_save_upd_timeout():
	emit_signal("score_changed")
	emit_signal("wood_changed")
	$CanvasLayer/Score.text = str(score)
	$"CanvasLayer/Stats/Log Count".text = str(wood)
	save_data()




func _on_log_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(convertlog , "scale" , Vector2(.9 , .9) , .1)





func _on_log_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(convertlog , "scale" , Vector2 ( 1 , 1) , .1)
	sconverttree()





func _on_convert_confirm_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(convertconfirm , "scale" , Vector2(.9 , .9) , .1)






func _on_convert_confirm_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(convertconfirm , "scale" , Vector2(1 , 1), .1)
	$CanvasLayer/Convert/Info.text = "SCORE = " + str(score) + " and LOGS = " + str(wood) + "\nWeather = " + str(weather) + " , Multiplier = " + str(weathermulti)






func _on_close_convert_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(closeconvert , "scale" , Vector2(.9 , .9) , .1)







func _on_close_convert_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(closeconvert , "scale" , Vector2(1 , 1) , .1)
	hconverttree()





func _on_weather_update_timeout():
	weatherupd()


func sunw():
	sun.visible = true
	rain.visible = false
	cloud.visible = false
	weathermulti = 1.5


func cloudyw():
	sun.visible = false
	rain.visible = false
	cloud.visible = true
	weathermulti = 1.0


func rainw():
	sun.visible = false
	rain.visible = true
	cloud.visible = false
	weathermulti = 0.7


func weatherupd():
	weather = get_weather()
	if weather == "Sunny":
		sunw()
		$"CanvasLayer/Stats/Weather Header".text = "Sunny"
	elif weather == "Cloudy":
		cloudyw()
		$"CanvasLayer/Stats/Weather Header".text = "Cloudy"
	elif weather == "Rain":
		rainw()
		$"CanvasLayer/Stats/Weather Header".text = "Rainy"







func _on_shop_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(shopopen , "scale" , Vector2(.9 ,.9) , .1)






func _on_shop_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(shopopen , "scale" , Vector2(1 , 1), .1)
