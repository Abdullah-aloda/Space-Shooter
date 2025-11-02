extends Node2D #if ur reading this I placed 6 or 7 67 jokes try to find all of them :))

#######################################-----------///||||\\\-----------##############################################

@export var enemy_scenes: Array[PackedScene] = [] #This creates a list of arrays of enemy scene files you can spawn
@onready var laser_container = $LaserContainer #Lasers which are spammed are contained here hence the name contaianer lol
@onready var timer = $EnemySpawnTimer #I created a timer for enemies which increase over time to increase difficulty!
@onready var enemy_container = $EnemyContainer #Now this is like the lasers one but its the opposite direction and for enemies!
@onready var hud = $UILayer/HUD #Reference to the HUD so we can update score and or lives
@onready var gos = $UILayer/GameOverScreen #I made a screen to reference when game is over and use it when player died
@onready var pb = $ParallaxBackground #This is a background that scrolls for motion effect (as if the spaceship is moving forward)
@onready var Laser_sound = $SFX/Laser_sound #PEW PEW
@onready var Hit_sound = $SFX/Hit_sound # AHHHHH
@onready var Explode_sound = $SFX/Explode_sound #BOOOOOM PLAYER DIED
@onready var LiveLost_sound = $SFX/LiveLost_sound # I think you would know this
@onready var player = $Player # The player node so the cache is on ready
@export var lives: int = 3 #The number of lives of a player is 3 (I might change this later since people think if a spaceship hits them thats a life so I dont want it to be confusing)

#####################################----VaRiAbLes-----###################################################

var score := 0: #I introduce score and set it at 0
	set(value): #Value is going to be set as score
		score = value
		hud.score = score # and will print on the HUD
var high_score # Created a variable for high score and later on saved it on games files
var scroll_speed = 67 #How fast the background scrolls I will change this in the future to go faster as player progress and players speed
var player_dead := false #How could the player start off dead?
var total_score

#######################################-----FuNcTiOns----#############################################

func _ready(): #We are ready for takeoff!!!
	var save_file = FileAccess.open("user://save.data", FileAccess.READ) #See if we can open saved data for highscore
	if save_file != null: # If it isnt null
		high_score = save_file.get_32() # Load the saved highscore
	else: #Otherwise
		high_score = 0 #So if we cant find a highscore we set it to 0 
		save_game() # and save it

	var total_file = FileAccess.open("user://total_score.data", FileAccess.READ) #See if we can open saved data for total score
	if total_file != null: # If it isnt null
		total_score = total_file.get_32() # Load the saved total score
	else: #Otherwise
		total_score = 0 #So if we cant find a total score we set it to 0
		save_total_score() # and save it
	score = 0 #and current score is 0
	player = get_tree().get_first_node_in_group("player") #We have to find player by group
	assert(player != null) #If no player is found I purposely made it crash so I can debug it
	player.killed.connect(_on_player_killed) # We see if we can see if player died
	player.laser_shot.connect(_on_player_laser_shot) # See if player shot










func save_total_score(): # Save the total score to file
	var file = FileAccess.open("user://total_score.data", FileAccess.WRITE)
	file.store_32(total_score)

func save_game(): #Saving!
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE) #Save files in a dedicated folder and write data
	save_file.store_32(high_score) #store it in a open file and write data of high score


func _process(delta): # This litterly runs every frame and (delta) is # seconds before last frame
	if Input.is_action_just_pressed("quit"): #Well godot made this pretty simple
		get_tree().quit() #this will quit the game
	elif Input.is_action_just_pressed("reset"): #If reset was just pressed
		get_tree().reload_current_scene() #The current scene reloads this is basically a retry we start over
	if timer.wait_time > 0.5: #So the timer between each enemy spawn first starts at 2 so im checking if its more then 2
		timer.wait_time -= delta*0.0067 # If it is I will take away delta from it very small amounts but this increases the spawn rate of enemies
	else: #otherwise
		timer.wait_time = 0.5 #so if it got to the point of being 0.5 spawn right this will be the lowest since anything faster is impossbile
	pb.scroll_offset.y += delta * scroll_speed #This will move the background smoothely
	if pb.scroll_offset.y >= 960: #We are checking if the background scrolled a full cycle since y dimensions up to 960
		pb.scroll_offset.y = 0 #reset it back to 0 then scroll away and continue cycle


func _on_player_laser_shot(laser_scene, location): #Function is called when player launches a laser pew pew
	var laser = laser_scene.instantiate() # Create a laser instance
	laser.global_position = location #Place it where player shot it
	laser_container.add_child(laser) #Make it appear on scene
	Laser_sound.play() #Cool laser sounds play! (I spent so long looking for this sound)


func lose_life(): #So function to lose 1 life out of the 3 remember
	if player_dead: #If a player has died just ignore
		return #the toughest line of code yet
	lives -= 1 # Lives will decreases by 1
	hud.set_lives(lives) #the lives will be shown
	if lives > 0: #If lives is above zero play
		LiveLost_sound.play() # play this sound
	if lives <= 0: #if its 0 and below (just incase idk why) 
		if is_instance_valid(player): #If hes even still alive lol
			player.die() #He dies!!! :(


func _on_enemy_spawn_timer_timeout() -> void: # This is from the spawn timer I called it
	var e = enemy_scenes.pick_random().instantiate()  #Find a random array and pick it
	e.global_position = Vector2(randf_range(50, 500), -50) #Place Just above the screen
	e.killed.connect(on_enemy_killed) #see if we killed any enemies for points or
	e.hit.connect(_on_enemy_hit) # or if we hit any for sound 
	enemy_container.add_child(e) # Add enemy to scene


func on_enemy_killed(points): #If we kill enemy we get awarded with points!
	score += points  #The current score is added with any extra points so always increasing
	if score > high_score: # If score is now greater then the current highscore (equal too doesnt matter)
		high_score = score #The new highscore will be the new (current) score you got


func _on_enemy_hit(): # If a enemy got hit
	Hit_sound.play() # special sound is played


func _on_player_killed(): # if the main player dies 
	if player_dead: # Want to make sure we dont run it twice I SPENT LIKE 5 HOURS WONDERING WHY MY CODE WASNT WORKING BECAUSE OF THIS >:(
		return 
	player_dead = true # He is indeed dead
	Explode_sound.stream.loop = false #The sound kept looping so I finally found a way to stop it
	Explode_sound.play() #BOOOOOM
	gos.set_score(score) # We get the score and set it
	gos.set_high_score(high_score) #same for highscore
	save_game() #save
	await get_tree().create_timer(0.67).timeout #hehe small timeout
	gos.visible = true #the screen to show retry score and highscore is now shown
