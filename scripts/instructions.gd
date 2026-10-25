extends Node2D


@onready var back: TextureButton = $CanvasLayer/previous
@onready var next: TextureButton = $CanvasLayer/next
@onready var cloud : Sprite2D = $CanvasLayer/Cloudy
@onready var rain: Sprite2D = $CanvasLayer/Rainy
@onready var sun: Sprite2D = $CanvasLayer/Sunny
@onready var tree:Sprite2D = $CanvasLayer/Tree
@onready var shop : Sprite2D = $CanvasLayer/ShopButton


var slide = 1


func _ready():
	back.pivot_offset = back.size / 2
	next.pivot_offset_ratio = next.size / 2
	slidesone()




func _on_previous_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(back , "scale" , Vector2(.9 ,.9), .1)





func _on_previous_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(back , "scale" , Vector2(1 , 1), .1)
	slide -= 1
	if slide == 0:
		get_tree().change_scene_to_file("res://scenes/start_scene.tscn")
	elif slide == 2:
		slidesone()
	elif slide == 3:
		slidestwo()





func _on_next_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(next , "scale" , Vector2(.9 ,.9), .1)
	slide += 1
	if slide == 2:
		slidesone()
	elif slide == 3:
		slidestwo()




func _on_next_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(next , "scale" , Vector2(1 , 1), .1)



func slidesone():
	cloud.visible = false
	rain.visible = false
	sun.visible = false
	tree.visible = true
	shop.visible = true
	next.visible = true
	$CanvasLayer/Content.text = "In this game you click on a tree to get score which can be converted into logs by clicking on the log icon in the game \nUsing logs you can buy items in the shop to upgrade click power. "



func slidestwo():
	cloud.visible = true
	rain.visible = true
	sun.visible = true
	tree.visible = false
	shop.visible = false
	next.visible = false
	$CanvasLayer/Content.text = "Every 5 minutes the weather changes which changes the conversion rate in the logs to score and also chances of disaster where you might lose logs and also sunny means a 1.5 multiplier , rain = 0.75 multiplier and cloudy = 1 multiplier."
