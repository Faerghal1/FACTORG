extends CharacterBody2D


const SPEED = 100

#placeholder movement code

var mult = 10
func _physics_process(delta):
	if not  Input.is_action_pressed("Shift"):
		if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("D"):
			position.x+=SPEED
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("A"):
			position.x-=SPEED
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("W"):
			position.y-=SPEED
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("S"):
			position.y+=SPEED
		
	else:
		if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("D"):
			position.x+=SPEED*mult
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("A"):
			position.x-=SPEED*mult
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("W"):
			position.y-=SPEED*mult
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("S"):
			position.y+=SPEED*mult
		
