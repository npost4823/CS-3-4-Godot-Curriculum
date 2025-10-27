extends Resource
class_name ItemResource

## Base class for all items in the game
## This includes weapons, materials, consumables, and more
## Students will learn to extend this class to create specialized item types

@export_group("Basic Information")
## The unique identifier for this item (e.g., "basic_pistol", "iron_ore")
@export var item_id: String = ""

## The display name shown to players
@export var item_name: String = "Unknown Item"

## A brief description of what this item does
@export_multiline var description: String = ""

## The icon shown in inventory and UI
@export var icon: Texture2D

@export_group("Inventory Properties")
## Can this item stack in the inventory?
@export var stackable: bool = false

## Maximum stack size (only relevant if stackable is true)
@export var max_stack_size: int = 99

## The rarity/quality tier of this item
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity: String = "Common"

## Base value for selling/trading (future feature)
@export var value: int = 0


## Virtual method that child classes can override to define custom behavior
## This gets called when the item is "used" from inventory
func use_item(user: Node) -> void:
	push_warning("use_item() not implemented for " + item_name)


## Returns a color based on rarity for UI highlighting
func get_rarity_color() -> Color:
	match rarity:
		"Common":
			return Color.WHITE
		"Uncommon":
			return Color.LIGHT_GREEN
		"Rare":
			return Color.DODGER_BLUE
		"Epic":
			return Color.MEDIUM_PURPLE
		"Legendary":
			return Color.ORANGE
		_:
			return Color.WHITE
