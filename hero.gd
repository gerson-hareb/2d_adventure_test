extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var is_attacking = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
		
	#Ataque
	if Input.is_action_just_pressed("Ataque"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		print("ataque")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.y < 0 and not is_on_floor():
		$AnimatedSprite2D.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		if is_on_floor():
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if direction == 0 and is_on_floor() and is_attacking != true:
			$AnimatedSprite2D.play("idle")
			

	move_and_slide()

#Usamos una señal del AnimatedSprite del heroe para indicar que la animacion de ataque termino, lo que cambia el estado de is_attacking a "false"
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
