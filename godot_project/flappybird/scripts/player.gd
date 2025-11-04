class_name Player extends CharacterBody2D #Class of player 

#########################################################################################################

signal laser_shot(laser_scene, location) # Signal sent when player fires a laser
signal killed #Signal sent when player dies

############################################################################################################

@export var speed = 300 # We make speed changable 

@onready var muzzle = $Muzzle # Muzzle which is right infront of our spaceship so laser comes out from there

@onready var ammo_label = get_node("/root/Game/UILayer/HUD/Ammo")

############################################################################################################

var laser_scene = preload("res://scenes/laser.tscn") #Laser scene preloaded for fast instancing

var shoot_cd := false #Effective Simple cooldown flag to prevent continuous firing

var ammo = 99

#############################################################################################################
func _process(_delta):  #This will run every frame to catch inputs
	ammo_label.text = "Ammo: " + str(ammo)
	if Input.is_action_pressed("shoot"): # If "space is the action" is just pressed (held)
		if !shoot_cd and ammo > 0: #This will only shoot if no cooldown and ammo is greater then 0
			shoot_cd = true # Shooting is now allowed
			ammo -= 1
			ammo_label.text = "Ammo: " + str(ammo)
			shoot()
			await get_tree().create_timer(0.5).timeout #This is the cooldown so you can only shoot every half a second at most
			shoot_cd = false #Now shooting isnt allowed
		if ammo == 0:
			var label = get_node("/root/Game/UILayer/NoAmmoLabel")
			label.text = "No ammo left! Buy more at the shop"
			label.visible = true
			await get_tree().create_timer(2).timeout
			label.visible = false

func _physics_process(_delta): #This is for the physics very basic but it works
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")) #So left right up down are all with W A S D
	velocity = direction * speed # Velocity is speed with direcition lol
	move_and_slide() #I had to learn the hard way this is NEEDED 
	position.x = clamp(position.x, -230, 230) #I created a border so the sprite can't go beyond visible borders
	position.y = clamp(position.y, -750, 100) #Same thing but for Y axis


func shoot(): #The shoot function
	laser_shot.emit(laser_scene, muzzle.global_position) # Tell whoever listens to create a laser at the muzzle


func die(): #Function EVEN THOUGH THIS CODE SEEMS SIMPLE I ALSO SPENTS COUNTLESS HOURS TRYING TO DEBUG!!! >:(
	var label = get_node("/root/Game/UILayer/NoAmmoLabel")
	label.visible = false
	killed.emit() #Notify that player has died
	get_tree().create_timer(0.01) #Very tiny wait to let the signals process
	queue_free() #This removes player node for scene
