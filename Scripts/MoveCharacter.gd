# Edited & Commented By: Jennifer Guajardo

#Start of traits and characteristics declared for the "CharacterBody2D"
extends CharacterBody2D
var gravity : Vector2
# Values with "@export" are altered at the discretion of those handling the Godot editor.
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?
#End of traits declared for "CharacterBody2D"


# Called when the node enters the scene tree for the first time.
func _ready():
	#Gravity, as it exists in the Godot, is simply an alteration of a node's X & Y position.
	gravity = Vector2(0, 100) # Initializing Gravity.
	# Below is a commented out thing I wanted to test.
	# At "50," the Character body is substaintially lighter, with a 
	# slight steer towards the right.
	# gravity = Vector2(20, 50) 
	
	# Jennifer's Note: I'm guessing "pass" just means to end  itself as a loop?
	
	pass # Replace with function body. 


func _get_input(): # Get input from the player every frame.
	# If's are conditional loops.
	
	## Unused
	# I was testing stuff in an attempt to emulate the movement I envisioned for HW8's character. 
	##This is a tad awkward.
		#if Input.is_action_just_pressed("move_right"):
			## The "just pressed" version.
			#rotate(1.5) # I got this by simulating a 90 degree rotation every frame. 1.5ish radians is equivalent to a 90 degree angle on ONE input, so I divided 1.5ish by 60.
			#velocity += Vector2(movement_speed,0)
		#
		#if Input.is_action_just_pressed("move_left"):
			## The "just pressed" version.
			#rotate(-1.5) # I got this by simulating a 90 degree rotation every frame. 1.5ish radians is equivalent to a 90 degree angle on ONE input, so I divided 1.5ish by 60.
			#velocity += Vector2(-movement_speed,0)
	
	if is_on_floor():
		#IMPORTANT: I CHANGED THE MOVEMENT SPEED FOR CHARACTER BODY IN THE DEMO SCENE.
		
		# Commented out another thing for the sake of testing. This is the "holding" version.
		# Don't mind me, just trying to get Floppy to work here. I was going through this during class.
		# Checking to see if any action here is called "move_left." Almost always something that the user has defined.
		
		if Input.is_action_pressed("move_left"): #Character body will move left if player presses "A," the key assigned to "move_left"
			# Player will also rotate counterclockwise.
			# For the below "rotate" call, I added the multiplication as a cheap way of getting it to turn faster.
			rotate(-0.0261799388333 * 2) # I got this by simulating a 90 degree rotation every frame. 1.5ish radians is equivalent to a 90 degree angle on ONE input, so I divided 1.5ish by 60.
			velocity += Vector2(-movement_speed,0)
			
		if Input.is_action_pressed("move_right"): #Character body will move right if player presses "D," the key assigned to "move_right."
			# Player will also rotate clockwise.
			# For the below "rotate" call, I added the multiplication as cheap way of getting it to turn faster.
			rotate(0.0261799388333 * 2) # I got this by simulating a 90 degree rotation every frame.
			# 1.5ish radians is equivalent to a 90 degree angle on ONE input, so I divided 1.5ish by 60.
			velocity += Vector2(movement_speed,0)
			
		#Unused crouch action. Repurposed as a speed increase.
		if Input.is_action_pressed("crouch"):
			# I tried to squish Godotbot, but I couldn't figure it out,
			# so decided to just alter the variable instead.
			movement_speed += 1 # Adding one "speed" for every frame this button is held. 
			# Just remember, the speed limit still applies. 
			pass
			
		# Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here.)
		# If you want a double-jump, you'd have to put this in the line with "if not is_on_floor():"
		if Input.is_action_just_pressed("jump"): 
			velocity += Vector2(1,-jump_height) # Player jumps.
			# Velocity for Vector2's Y-axis is adjusted to match "Jump Height" variable set to character body.

	if not is_on_floor():
	# Horizontal_air_coeffictent (I'm calling it "HAC") is representitive of how much you can move while in air.
	# This is the third variable down from the list.
	# In both the left and right variants, the HAC has to be set on the character body for this to work.
	# If using a number between 0 & 1, movement is more limited in the air.
	# If HAC is set to 0, then the player/character body will stay committed to their trajectory regardless of input.
	# An HAC higher than one will result in more movement possibility in the air.
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

func _limit_speed(): # Sets and maintains the speed limit every frame.
	# If you're directly changing the velocity, you don't wanna mess with more than one value at a time.
	# Remember, negative values means left with X & up with Y.
	
	# I know both of these apply the limit.
	# If player's velocity tries to go beyond that, they will
	# be limited by the speedlimit set on the character body.
	
	# I'm guessing the Y position is called, but unchanged
	# because of how height doesn't seem to be taken accounted for with speed limit.
	#
	if velocity.x > speed_limit: 
		#Player will go speedlimit horizontally. Vertical position is unaffected because that's "Apply Gravity's" job.
		velocity = Vector2(speed_limit, velocity.y) 

	if velocity.x < -speed_limit:
		#Player will go speedlimit horizontally. Vertical position is unaffected because that's "Apply Gravity's" job.
		velocity = Vector2(-speed_limit, velocity.y)

func _apply_friction(): # Applies friction when no "right" or "left" input is present, ONLY when the player is ON the floor.
	# If the player is on the floor and not pressing left or right.
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0) #Slows character body/player down.
		if abs(velocity.x) < 5: #Checking for extremely tiny values. 
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero.
			#If the above wasn't applied, then the character body/player would face EXTREMELY tiny sliding that's bound to frusturate.

func _apply_gravity(): 	# Applies gravity every frame.
	# "gravity" is declared from "func _ready():"
	if not is_on_floor(): #Checks if the player is not on the ground.
		velocity += gravity #If yes, throw some gravity at them.


func _physics_process(delta): # Called every frame. 'delta' is the elapsed time since the previous frame.
	# For the sake of organization, all functions with the physic's are delegated to these called methods.
	_get_input() #Will check if player pressed a button.
	_limit_speed() #Sets and maintains a speed limit based on what they enter for a given scene's character body.
	_apply_friction() #Sets and maintains fricition based on what a user enter's for a given scene's character body.
	_apply_gravity() #Applies gravity. This method is connected to "func _ready():" where the gravity variable is declared.
	print(movement_speed) # Prints movement speed in the console for my testing purposes.
	move_and_slide() # This is a function that Godot gives us. Makes us do all those things we wanted it to do.
	pass
