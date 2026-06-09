# Deals damage_per_hit * (total times player was damaged this combat).
extends BaseAction

func is_instant_action() -> bool:
	return true

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])

	for processor in action_interceptor_processors:
		var damage_per_hit: int = processor.get_shadowed_action_values("damage", 4)
		var combat_stats: CombatStatsData = Global.get_combat_stats()
		var hit_count: int = combat_stats.get_total_stat(CombatStatsData.STATS.PLAYER_DAMAGED_COUNT)
		var total_damage: int = damage_per_hit * hit_count

		if total_damage <= 0:
			return

		if parent_combatant != null:
			parent_combatant.play_attack_animation()

		var attack_data: Array[Dictionary] = [{
			Scripts.ACTION_ATTACK: {
				"damage": total_damage,
				"time_delay": 0.25,
				"actions_on_lethal": []
			}
		}]
		var attack_actions: Array[BaseAction] = ActionGenerator.create_actions(parent_combatant, card_play_request, targets, attack_data, self)
		ActionHandler.add_actions(attack_actions)
