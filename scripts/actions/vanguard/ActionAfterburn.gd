# Doubles the player's current Momentum by applying it again.
extends BaseAction

func is_instant_action() -> bool:
	return true

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([null])

	for _processor in action_interceptor_processors:
		var momentum: int = parent_combatant.get_status_charges("status_effect_momentum")
		if momentum <= 0:
			return

		var apply_data: Array[Dictionary] = [{
			Scripts.ACTION_APPLY_STATUS: {
				"status_effect_object_id": "status_effect_momentum",
				"status_charge_amount": momentum,
				"time_delay": 0.0,
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT
			}
		}]
		var apply_actions: Array[BaseAction] = ActionGenerator.create_actions(parent_combatant, card_play_request, [parent_combatant], apply_data, self)
		ActionHandler.add_actions(apply_actions)
