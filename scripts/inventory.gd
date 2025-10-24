extends Node

class_name inventory

var my_inventory: Array[items] = []
var current_item: int = 0
var max_items: int = 10


func _ready() -> void:
	display_inventory(current_item)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_up"):
		current_item -= 1
		if current_item <0:
			current_item = 0
		
	if Input.is_action_just_pressed("inventory_down"):
		current_item += 1
		if current_item > my_inventory.size()-1:
			current_item = my_inventory.size()-1
			display_inventory(current_item)

func display_inventory(index: int):
	print("The current item is " + my_inventory[current_item].name)
	print("It costs " +str(my_inventory[current_item].cost))

func add_inventory(new_item:Resource):
	if my_inventory.size() < max_items:
		my_inventory.append()
	else: print("The inventory is already full")


func remove_inventory(item_to_use: Resource):
	#what item in the list am I trying to remove?
	#what if that item is not in the inventorys
	pass
