class_name EnemyState extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine

#what happens when we initialise this state 
func init() -> void:
	pass

#what happens when the player enters this state
func enter() -> void:
	pass

func exit() -> void:
	pass

func process( _delta : float) -> EnemyState:
	return null

func Physics( _delta : float ) -> EnemyState:
	return null
