extends Node
class_name InventorySystem

## Manages player inventory
## Stores weapons and handles equipment

#signal inventory_changed
#
## List of owned weapons
#var weapons: Array[WeaponResource] = []
#
## Currently equipped weapon
#var equipped_weapon: WeaponResource = null
#
#
### Add a weapon to inventory
### Returns true if weapon was added successfully
#func add_weapon(weapon: WeaponResource) -> bool:
	#if not weapon:
		#return false
#
	#weapons.append(weapon)
	#print("Acquired weapon: " + weapon.item_name)
	#inventory_changed.emit()
	#return true
#
#
### Equip a weapon
### Returns true if weapon was equipped successfully
#func equip_weapon(weapon: WeaponResource) -> bool:
	#if not weapon:
		#return false
#
	#equipped_weapon = weapon
	#print("Equipped: " + weapon.item_name)
	#inventory_changed.emit()
	#return true
