extends Control

##################################################################################################################s

func _on_restart_button_pressed(): #A node we took out to see if the button is press
	get_tree().reload_current_scene() #Reload the current scene to basically start over (retry)
	
func _on_shop_button_pressed():
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func set_score(value): #The score is the number user got
	$Panel/Score.text = "Score: " + str(value) #update the HUD to display score after death

func set_high_score(value): #This is for highscore
	$Panel/HighScore.text = "Hi-Score: " + str(value) #If new highscore we put it here otherwise it remains the same
