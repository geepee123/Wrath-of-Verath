# Deals damage equal to the player's current Block value.
extends BaseAction

func is_instant_action() -> bool:
	return true

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])

	for _processor in action_interceptor_processors:
		if parent_combatant == null:
			return

		var block_damage: int = parent_combatant.get_block()
		if block_damage <= 0:
			return

		parent_combatant.play_attack_animation()

		var attack_data: Array[Dictionary] = [{
			Scripts.ACTION_ATTACK: {
				"damage": block_damage,
				"time_delay": 0.25,
				"actions_on_lethal": []
			}
		}]
		var attack_actions: Array[BaseAction] = ActionGenerator.create_actions(parent_combatant, card_play_request, targets, attack_data, self)
		ActionHandler.add_actions(attack_actions)
