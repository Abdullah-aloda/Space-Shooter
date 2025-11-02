extends Control #Extends control into the script

#####################################################################################################################

@onready var score = $Score: #Find the Score label when the scene starts so we can change its text later
	set(value): # Function to receive new score value
		score.text = "Score: " + str(value) #The score text will show users current score based off aliens killed
		
@onready var lives = $Lives #Find the Lives label when the scene starts so we can update it

@onready var ammo = $Ammo:
	set(ammo):
		ammo.text = "Ammo: " + str(ammo)

#####################################################################################################################

var _lives: int = 3 #User Is started off with 3 lives

#####################################################################################################################

func set_lives(value:int): #Created a new function for lives to reply with how many lives left if none dead
	_lives = value #This stores new lives count
	if _lives > 0: #This checks for if lives are more then 0
		lives.text = "LIVES: " + str(_lives) # if lives is more then 0 a print statment is seen showing LIVES: # (Where # is amount of lives left)
	else: #Otherwise if lives are NOT more then 0
		lives.text = "DEAD" #The text will now show the playe has died :(
