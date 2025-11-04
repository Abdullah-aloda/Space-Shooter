class_name Enemy extends Area2D #Reusable enemy class is created

##########################################################################################################

signal killed(points) #emits when enemy dies for point system and score 
signal hit #emits when enemy has taken damage but not dead 

###########################################################################################################

@onready var hud = get_tree().get_root().get_node("Game/UILayer/HUD")
@export var speed = 150 # The speed is set to 150 so relatively slow to player which is 300 but changable in the inspector
@export var hp = 1 # Hp is set to 1 but this is changable in the inspector based of the enemy I will later add more
@export var points = 10 #Worth 10 points but this is changable in the inspector
@export var lives = 3 #Needed this to see if it goes out of bounds and lose a player his life

##########################################################################################################

func _physics_process(delta): #Since for any movement we need this
	global_position.y += speed * delta #Same thing as last

func die(): #If it dies (anything I made this inter changable so it can be used for player and enemy)
	queue_free() #goes from screen 
	hit.emit() #the sound of being hit

func _on_body_entered(body): #If area enters another area (body)
	if body is Player: #Sees if the body is the player
		body.die() # Player will die
		die() #make sure hes dead

func lose_life(): #This is to see if it crosses the boundary to lose 1 out of our 3 lives
	lives -= 1 # 1 life is lost
	hud.lives = lives #updates the lives on hud
	if lives <= 0: #if lives is now 0 or less just incase
		die() # player dies

func _on_visible_on_screen_notifier_2d_screen_exited() -> void: # Another node we took out to check if left screen
	if global_position.y > get_viewport_rect().size.y: # If exits below the visible area 
		get_tree().get_root().get_node("Game").lose_life() # Emits ot game node that player has lost 1 life form the 3
	queue_free() #Vanishes it woah

func take_damage(amount): # Called to take damage of the enemy
	hp -= amount  #hp of enemy is subtracted from the damage
	if hp <= 0: #if enemy hp is now 0 or below
		killed.emit(points) #it is killed  and points rewarded
		die() #that enemy dies and vanishes
	else: #otherwise
		hit.emit() #the hit sound will playa
