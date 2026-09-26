extends PanelContainer

@onready var amount_label: Label = %AmountLabel

var _displayed: float = 0.0
var _tween: Tween

#func _ready() -> void:
#	GameState.money_changed.connect(_on_money_changed)
	#_set_display(GameState.money)

func _on_money_changed(new_amount: int) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_method(_set_display, _displayed, float(new_amount), 0.4)
	pivot_offset = size / 2.0
	scale = Vector2(1.15, 1.15)
	_tween.tween_property(self, "scale", Vector2.ONE, 0.2)

func _set_display(value: float) -> void:
	_displayed = value
	amount_label.text = str(int(value))
