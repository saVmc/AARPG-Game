class_name State extends Node
## Stores a reference to the player
static var player: Player
static var state_machine : PlayerStateMachine
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init() -> void:
	pass

#what happens when the player enters this state
func enter() -> void:
	pass


func exit() -> void:
	pass

func process( _delta : float) -> State:
	return null

func physics( _delta : float ) -> State:
	return null

func handle_input( _event: InputEvent ) -> State:
	return null
