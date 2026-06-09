# Deals damage equal to (damage_per_momentum * Momentum stacks), then resets Momentum to 0.
extends BaseAction

func is_instant_action() -> bool:
	return true

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])

	for processor in action_interceptor_processors:
		var momentum: int = parent_combatant.get_status_charges("status_effect_momentum")
		if momentum <= 0:
			return

		if parent_combatant != null:
			parent_combatant.play_attack_animation()

		var damage_per_momentum: int = processor.get_shadowed_action_values("damage", 8)
		var total_damage: int = damage_per_momentum * momentum
		var delay: float = processor.get_shadowed_action_values("time_delay", 0.25)

		var attack_data: Array[Dictionary] = [{
			Scripts.ACTION_ATTACK: {
				"damage": total_damage,
				"time_delay": delay,
				"actions_on_lethal": []
			}
		}]
		# Add reset first so it ends up below the attack on the LIFO stack — attack fires first.
		var reset_data: Array[Dictionary] = [{
			Scripts.ACTION_APPLY_STATUS: {
				"status_effect_object_id": "status_effect_momentum",
				"status_charge_amount": -999,
				"time_delay": 0.0,
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT
			}
		}]
		var reset_actions: Array[BaseAction] = ActionGenerator.create_actions(parent_combatant, card_play_request, [parent_combatant], reset_data, self)
		ActionHandler.add_actions(reset_actions)

		var attack_actions: Array[BaseAction] = ActionGenerator.create_actions(parent_combatant, card_play_request, targets, attack_data, self)
		ActionHandler.add_actions(attack_actions)
