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
@onready var xone:TextureButton = $CanvasLayer/Convert/xone
@onready var xten:TextureButton = $CanvasLayer/Convert/xten
@onready var xhundred: TextureButton = $CanvasLayer/Convert/xhundred
@onready var xmax : TextureButton = $CanvasLayer/Convert/max
@onready var xhalf: TextureButton = $CanvasLayer/Convert/half
@onready var xplus: TextureButton = $CanvasLayer/Convert/plus
@onready var xminus : TextureButton = $CanvasLayer/Convert/minus
@onready var sunnyb: Sprite2D = $CanvasLayer/ClearBackground
@onready var rainb: Sprite2D = $CanvasLayer/Rain
@onready var cloudyb : Sprite2D = $CanvasLayer/Cloudy
@onready var shopanim: AnimationPlayer = $CanvasLayer/Shopline/AnimationPlayer
@onready var shopclose: TextureButton = $"CanvasLayer/Shopline/Shop Close"
@onready var buyone: TextureButton = $"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 1/Click + 1/Buy1"
@onready var buyten: TextureButton = $"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 2/Click + 10/Buy10"
@onready var buyhundred : TextureButton = $"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 3/Click + 100/Buy100"
@onready var buyk : TextureButton = $"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 4/Click + 1000/Buy1000"
@onready var buytenk : TextureButton = $"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 5/Click + 10000/Buy10000"
@onready var changebox: Sprite2D = $CanvasLayer/Change
@onready var lfeffect:CPUParticles2D = $CanvasLayer/Tree/leaf



var score = 0
var wood = 0
var weather = "Nothing"
var weathermulti = 1.0
var change = 1
var converttext = 0
var click = 1
var clickone = 75
var amntowned = 0
var clickten = 650
var amntownedten = 0
var clickhundred = 6000
var amntownedhundred = 0
var clickk = 55000
var amntownedk = 0
var clicktenk = 500000
var amntowned10k = 0
var damage = "Nothing"
var loss = 0


var rarities = {"Cloudy" : 1000,
				"Sunny" : 500,
				"Rain" : 250}


var disasters = {"Stolen" : 1000,
				"Eaten" : 500,
				"Heavy Tax" : 250,
				"Raid" : 1,}


var rng = RandomNumberGenerator.new()
var drng = RandomNumberGenerator.new()


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



func get_disaster():
	rng.randomize()
	
	var sums = 0
	
	for r in disasters:
		sums += disasters[r]
		
	var itemt = rng.randi_range(0 , sums)
	
	for r in disasters:
		if itemt <= disasters[r]:
			return r
		itemt -= disasters[r]



signal score_changed
signal wood_changed
signal click_changed
signal clickone_changed
signal amntowned_changed
signal clickten_changed
signal amntownedten_changed
signal clickhundred_changed
signal amntownedhundred_changed
signal clickk_changed
signal amntownedk_changed
signal clicktenk_changed
signal amntowned10k_changed

func save_data():
	var data = {
		"score": score,
		"wood": wood,
		"click": click,
		"clickone": clickone,
		"amntowned": amntowned,
		"clickten": clickten,
		"amntownedten": amntownedten,  
		"clickhundred": clickhundred,  
		"amntownedhundred": amntownedhundred,   
		"clickk": clickk,   
		"amntownedk": amntownedk,  
		"clicktenk" : clicktenk,   
		"amntowned10k": amntowned10k
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
			click = data.get("click" , 1)
			clickone = data.get("clickone" , 75)
			amntowned = data.get("amntowned" , 0)
			clickten = data.get("clickten" , 650)
			amntownedten = data.get("amntownedten" , 0)
			clickhundred = data.get("clickhundred" , 6000)
			amntownedhundred = data.get("amntownedhundred" , 0)
			clickk = data.get("clickk" , 55000)
			amntownedk = data.get("amntownedk" , 0)
			clicktenk = data.get("clicktenk" , 500000)
			amntowned10k = data.get("amntowned10k" , 0)
	else:
		save_data()



func shopdload():
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 1/Click + 1/Cost".text ="COST = " + str(clickone)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 1/Click + 1/Amnt Owned".text = str(amntowned)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 2/Click + 10/Cost 10".text ="COST = " + str(clickten)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 2/Click + 10/Amnt Owned 10".text = str(amntownedten)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 3/Click + 100/Cost 100".text = "COST = " + str(clickhundred)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 3/Click + 100/Amnt Owned 100".text = str(amntownedhundred)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 4/Click + 1000/Cost 1000".text = "COST = " + str(clickk)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 4/Click + 1000/Amnt Owned 1000".text = str(amntownedk)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 5/Click + 10000/Cost 10000".text ="COST = " + str(clicktenk)
	$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 5/Click + 10000/Amnt Owned 10000".text = str(amntowned10k)





func _ready():
	load_data()
	shopdload()
	tree.pivot_offset = tree.size / 2
	convertlog.pivot_offset = convertlog.size / 2
	closeconvert.pivot_offset = closeconvert.size / 2
	convertconfirm.pivot_offset = convertconfirm.size / 2
	shopopen.pivot_offset = shopopen.size / 2
	xplus.pivot_offset = xplus.size / 2
	xminus.pivot_offset = xminus.size / 2
	xone.pivot_offset = xone.size / 2
	xten.pivot_offset = xten.size / 2
	xhundred.pivot_offset = xhundred.size / 2
	xmax.pivot_offset = xmax.size / 2
	xhalf.pivot_offset = xhalf.size / 2
	shopclose.pivot_offset = shopclose.size / 2
	buyone.pivot_offset = buyone.size / 2
	buyten.pivot_offset = buyten.size / 2
	buyhundred.pivot_offset = buyhundred.size / 2
	buyk.pivot_offset = buyk.size / 2
	buytenk.pivot_offset = buytenk.size / 2
	changebox.visible = false
	$CanvasLayer/Score.text = str(score)
	$"CanvasLayer/Stats/Log Count".text = str(wood)
	hconverttree()
	weatherupd()




func sconverttree():
	convertdg.visible = true
	change = 1
	converttext = 0
	$CanvasLayer/Convert/Info.text = "SCORE = " + str(score) + " and LOGS = " + str(wood) + "\nWeather = " + str(weather) + " , Multiplier = " + str(weathermulti)
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)
	$CanvasLayer/Convert/Ctext.text = str(converttext)


func hconverttree():
	convertdg.visible = false




func _on_tree_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(tree , "scale" , Vector2(.9 , .9), .1)



func _on_tree_button_up():
	if convertdg.visible == false:
		var tween = get_tree().create_tween()
		tween.tween_property(tree , "scale" , Vector2(1 , 1), .1)
		score += click
		$CanvasLayer/Score.text = str(score)
		emit_signal("score_changed")
		save_data()
		lfeffect.emitting = true
	else:
		pass





func _on_save_upd_timeout():
	emit_signal("score_changed")
	emit_signal("wood_changed")
	emit_signal("click_changed")
	emit_signal("clickone_changed")
	emit_signal("amntowned_changed")
	emit_signal("clickten_changed")
	emit_signal("amntownedten_changed")
	emit_signal("clickhundred_changed")
	emit_signal("amntownedhundred_changed")
	emit_signal("clickk_changed")
	emit_signal("amntownedk_changed")
	emit_signal("clicktenk_changed")
	emit_signal("amntowned10k_changed")
	$CanvasLayer/cp.text = "CP = " + str(click)
	$CanvasLayer/Score.text = str(score)
	$"CanvasLayer/Stats/Log Count".text = str(wood)
	save_data()
	$CanvasLayer/Convert/Amnt.text = "Logs Earned = " + str(converttext * weathermulti)
	



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
	if score >= converttext:
		score -= converttext
		wood += (converttext * weathermulti)
		converttext = 0
		$CanvasLayer/Convert/Ctext.text = str(converttext)






func _on_close_convert_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(closeconvert , "scale" , Vector2(.9 , .9) , .1)







func _on_close_convert_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(closeconvert , "scale" , Vector2(1 , 1) , .1)
	hconverttree()





func _on_weather_update_timeout():
	weatherupd()
	disastersupd()
	changebox.visible = true
	await get_tree().create_timer(1).timeout
	changebox.visible = false


func sunw():
	sun.visible = true
	rain.visible = false
	cloud.visible = false
	rainb.visible = false
	cloudyb.visible = false
	sunnyb.visible = true
	weathermulti = 1.5
	$CanvasLayer/Stats/InfoM.text = "Multiplier = " + str(weathermulti)


func cloudyw():
	sun.visible = false
	rain.visible = false
	cloud.visible = true
	rainb.visible = false
	cloudyb.visible = true
	sunnyb.visible = false
	weathermulti = 1.0
	$CanvasLayer/Stats/InfoM.text = "Multiplier = " + str(weathermulti)


func rainw():
	sun.visible = false
	rain.visible = true
	cloud.visible = false
	rainb.visible = true
	cloudyb.visible = false
	sunnyb.visible = false
	weathermulti = 0.7
	$CanvasLayer/Stats/InfoM.text = "Multiplier = " + str(weathermulti)


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



func disastersupd():
	damage = get_disaster()
	if damage == "Stolen":
		loss = 100
		if wood >= loss:
			wood -= loss
		$CanvasLayer/Ground/dheader.text = "Your LOGS was stolen , loss = " + str(loss)
	elif damage == "Eaten":
		loss = 175
		if wood >= loss:
			wood -= loss
		$CanvasLayer/Ground/dheader.text = "Your LOGS was Eaten By a RAT , loss = " + str(loss)
	elif damage == "Heavy Tax":
		loss = 250
		if wood >= loss:
			wood -= loss
		$CanvasLayer/Ground/dheader.text = "Your LOGS was TAXED , loss = " + str(loss)
	elif damage == "Raid":
		loss = 750
		if wood >= loss:
			wood -= loss
		$CanvasLayer/Ground/dheader.text = "Your LOGS was RAIDED , loss = " + str(loss)


func _on_shop_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(shopopen , "scale" , Vector2(.9 ,.9) , .1)






func _on_shop_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(shopopen , "scale" , Vector2(1 , 1), .1)
	shopopen.visible = false
	shopanim.play("Shop Transition")





func _on_plus_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xplus , "scale", Vector2(.9 , .9),.1)






func _on_plus_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xplus , "scale" ,Vector2(1,1),.1)
	if score >= converttext:
		converttext += change
		$CanvasLayer/Convert/Ctext.text = str(converttext)







func _on_minus_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xminus , "scale" , Vector2(.9 , .9),.1)





func _on_minus_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xminus , "scale" , Vector2(1 , 1) , .1)
	if converttext >= change:
		converttext -= change
		$CanvasLayer/Convert/Ctext.text = str(converttext)





func _on_xone_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xone , "scale" , Vector2(.9 , .9) , .1)





func _on_xone_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xone , "scale" , Vector2(1 , 1),.1)
	change = 1
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)





func _on_xten_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xten , "scale" , Vector2(.9 , .9) ,.1)






func _on_xten_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xten , "scale" , Vector2(1 , 1) , .1)
	change = 10
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)





func _on_xhundred_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xhundred , "scale" , Vector2(.9 , .9) , .1)






func _on_xhundred_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xhundred , "scale" , Vector2(1 , 1) ,.1)
	change = 100
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)





func _on_max_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xmax , "scale" , Vector2(.9 ,.9),.1)





func _on_max_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xmax , "scale" , Vector2(1 , 1), .1)
	change = score
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)





func _on_half_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(xhalf , "scale" , Vector2(.9 ,.9) , .1)






func _on_half_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(xhalf , "scale" , Vector2(1 , 1) ,.1)
	change = (score / 2)
	$CanvasLayer/Convert/Change.text = "Change By = " + str(change)





func _on_shop_close_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(shopclose , "scale" , Vector2(.9 , .9) ,.1)





func _on_shop_close_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(shopclose , "scale" , Vector2(1 , 1), .1)
	shopanim.play("Shop Close Animation")
	shopopen.visible = true





func _on_buy_1_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(buyone , "scale" , Vector2(.9 ,.9) , .1)





func _on_buy_1_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(buyone , "scale" , Vector2(1 , 1) , .1)
	if wood >= clickone:
		wood -= clickone
		click += 1
		clickone += 25
		amntowned += 1
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 1/Click + 1/Cost".text ="COST = " + str(clickone)
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 1/Click + 1/Amnt Owned".text = str(amntowned)






func _on_buy_10_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(buyten , "scale" , Vector2(.9 ,.9) ,.1)






func _on_buy_10_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(buyten , "scale" , Vector2(1 , 1), .1)
	if wood >= clickten:
		wood -= clickten
		click += 10
		clickten += 175
		amntownedten += 1
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 2/Click + 10/Cost 10".text ="COST = " + str(clickten)
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 2/Click + 10/Amnt Owned 10".text = str(amntownedten)






func _on_buy_100_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(buyhundred , "scale" , Vector2(.9 ,.9), .1)





func _on_buy_100_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(buyhundred , "scale" , Vector2(1 , 1), .1)
	if wood >= clickhundred:
		wood -= clickhundred
		click += 100
		clickhundred += 1250
		amntownedhundred += 1
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 3/Click + 100/Cost 100".text = "COST = " + str(clickhundred)
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 3/Click + 100/Amnt Owned 100".text = str(amntownedhundred)






func _on_buy_1000_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(buyk , "scale" , Vector2(.9 ,.9), .1)






func _on_buy_1000_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(buyk , "scale" , Vector2(1 , 1) , .1)
	if wood >= clickk:
		wood -= clickk
		click += 1000
		clickk += 11550
		amntownedk += 1
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 4/Click + 1000/Cost 1000".text = "COST = " + str(clickk)
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 4/Click + 1000/Amnt Owned 1000".text = str(amntownedk)






func _on_buy_10000_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(buytenk , "scale" , Vector2(.9 ,.9) , .1)




func _on_buy_10000_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(buytenk , "scale" , Vector2(1 , 1) ,.1)
	if wood >= clicktenk:
		wood -= clicktenk
		click += 10000
		clicktenk += 105000
		amntowned10k += 1
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 5/Click + 10000/Cost 10000".text ="COST = " + str(clicktenk)
		$"CanvasLayer/Shopline/ScrollContainer/VBoxContainer/Control 5/Click + 10000/Amnt Owned 10000".text = str(amntowned10k)
