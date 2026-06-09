# Validates the player's current charge count on a given status effect.
extends BaseValidator

func _validation(_card_data: CardData, action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var status_id: String = _get_validator_value("status_effect_object_id", values, action, "")
	if status_id.is_empty():
		return false

	var operator: String = _get_validator_value("operator", values, action, ">=")
	var comparison_value: int = _get_validator_value("comparison_value", values, action, 1)

	var players: Array[Node] = Global.get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return false

	var player: BaseCombatant = players[0] as BaseCombatant
	var charges: int = player.get_status_charges(status_id)

	return _compare(charges, comparison_value, operator)
