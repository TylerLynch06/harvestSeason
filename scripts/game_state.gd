extends Node

signal money_changed(new_amount: int)

var money: int = 0:
	set(value):
		money = max(value, 0)
		money_changed.emit(money)

func add_money(amount: int) -> void:
	money += amount

func spend_money(amount: int) -> bool:
	if money < amount:
		return false
	money -= amount
	return true
