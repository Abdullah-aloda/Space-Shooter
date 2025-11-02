extends Control

@onready var ammo = get_node("/root/Game/UILayer/HUD/Ammo")

@onready var score_label = $ScoreShopLabel # Find the Score label when the scene starts so we can change its text later

func update_score_display(value):
	score_label.text = "Score: " + str(value) # The score text will show users current score based off aliens killed

func _on_BuyAmmo_pressed():
	var player = get_node("/root/Game/Player") 
	if player.score >= 100:
		player.ammo += 50
		player.score -= 100
		print("Bought 50 ammo!")
		ammo.text = "Ammo: " + str(player.ammo)
		update_score_display(player.score) # Update the score label after purchase 
	else:
		print("Not enough score!")


func _on_Back_pressed():
	get_tree().change_scene("res://GameOverScreen.tscn")
