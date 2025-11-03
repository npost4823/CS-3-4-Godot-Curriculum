extends Node

class_name inventory

var my_inventory: Array[items] = []
var current_item: int = 0
var max_items: int = 10


"res://items/stick.tres"



func _ready() -> void:
	var potion = preload("res://items/potion.tres")
	var coin = preload("res://items/coin.tres")
	var sword = preload("res://items/sword.tres")
	var stick = preload("res://items/stick.tres")
	add_inventory(potion)
	add_inventory(sword)
	add_inventory(coin)
	add_inventory(stick)
	if my_inventory.is_empty():
		return
	display_inventory(current_item)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_up"):
		current_item -= 1
		current_item = clamp(current_item, 0, max(0, my_inventory.size() - 1))
		display_inventory(current_item)

	if Input.is_action_just_pressed("inventory_down"):
		current_item += 1
		current_item = clamp(current_item, 0, max(0, my_inventory.size() - 1))
		display_inventory(current_item)
	
	if Input.is_action_just_pressed("delete_inventory"):
		remove_inventory()

func display_inventory(index: int) -> void:
	if my_inventory.is_empty():
		print("Inventory is empty.")
		return

	if index < 0 or index >= my_inventory.size():
		print("Invalid inventory index:", index)
		return

	var current = my_inventory[index]
	print("The current item is " + current.name)
	print("It costs " + str(current.cost))

func add_inventory(new_item: Resource) -> void:
	if my_inventory.size() >= max_items:
		print("The inventory is already full")
		return
	if not (new_item is items):
		print("add_inventory: given resource is not an 'items' type")
		return
	my_inventory.append(new_item)


func remove_inventory():
	if my_inventory.is_empty():
		return

	if current_item < 0 or current_item >= my_inventory.size():
		print("Invalid current item index")
		return

	my_inventory.remove_at(current_item)

	# Adjust current_item to stay in bounds
	current_item = clamp(current_item, 0, max(0, my_inventory.size() - 1))
