extends Node
class_name InventorySystem

## Manages player inventory
## Stores ItemResources and their quantities
## Students will expand this to handle equipped weapons and crafting materials

signal inventory_changed

# Dictionary of item_id -> quantity
var materials: Dictionary = {}

# List of owned weapons
var weapons: Array[WeaponResource] = []

# Currently equipped weapon
var equipped_weapon: WeaponResource = null


## Add a material to inventory
## Returns true if material was added successfully
func add_material(material_id: String, amount: int = 1) -> bool:
	if material_id == "" or amount <= 0:
		return false

	if materials.has(material_id):
		materials[material_id] += amount
	else:
		materials[material_id] = amount

	print("Added " + str(amount) + "x " + material_id)
	inventory_changed.emit()
	return true


## Remove materials from inventory
func remove_material(material_id: String, amount: int = 1) -> bool:
	if not materials.has(material_id) or materials[material_id] < amount:
		return false

	materials[material_id] -= amount
	if materials[material_id] <= 0:
		materials.erase(material_id)

	inventory_changed.emit()
	return true


## Get count of a specific material
func get_material_count(material_id: String) -> int:
	return materials.get(material_id, 0)


## Add a weapon to inventory
## Returns true if weapon was added successfully
func add_weapon(weapon: WeaponResource) -> bool:
	if not weapon:
		return false

	weapons.append(weapon)
	print("Acquired weapon: " + weapon.item_name)
	inventory_changed.emit()
	return true


## Equip a weapon
## Returns true if weapon was equipped successfully
func equip_weapon(weapon: WeaponResource) -> bool:
	if not weapon:
		return false

	equipped_weapon = weapon
	print("Equipped: " + weapon.item_name)
	inventory_changed.emit()
	return true


## Check if player has required materials for a recipe
func has_materials(required_materials: Dictionary) -> bool:
	for material_id in required_materials.keys():
		var needed = required_materials[material_id]
		var has = get_material_count(material_id)
		if has < needed:
			return false
	return true


## Consume materials for crafting
func consume_materials(required_materials: Dictionary) -> bool:
	# First check if we have enough
	if not has_materials(required_materials):
		return false

	# Then consume them
	for material_id in required_materials.keys():
		remove_material(material_id, required_materials[material_id])

	return true
