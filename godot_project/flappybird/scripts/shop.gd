extends Control

@onready var score_label = $ShopScore
@onready var ammo_label = $AmmoShopLabel

var game
var player

func update_score_display(value):
	score_label.text = "Score: " + str(value)

func update_ammo_display(value):
	ammo_label.text = "Ammo: " + str(value)

func _ready():
	if game:
		update_score_display(game.score)
	else:
		print("Game not passed in")

	if player:
		update_ammo_display(player.ammo)
	else:
		print("Player not passed in")
		


func _on_buy_ammo_pressed() -> void:
	if game and player and game.score >= 100:
		player.ammo += 50
		game.score -= 100
		print("Bought 50 ammo!")
		update_ammo_display(player.ammo)
		update_score_display(game.score)
	else:
		print("Not enough score or missing references!")


func _on_shop_return_pressed() -> void:
	if game:
		game.show() 
	queue_free() 
