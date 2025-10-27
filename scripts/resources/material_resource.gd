extends ItemResource
class_name MaterialResource

## Resource for crafting materials that drop from enemies
## These are used in recipes to craft or upgrade weapons
## Example: Iron Ore, Wood, Magic Essence, etc.

@export_group("Material Properties")
## What tier of crafting recipes can use this material?
@export_range(1, 5) var material_tier: int = 1

## Can this material be dropped by enemies?
@export var drops_from_enemies: bool = true

## What types of recipes commonly use this? (tags for filtering)
@export var material_tags: Array[String] = []


## Override the use_item method - materials can't be directly used
func use_item(user: Node) -> void:
	push_warning(item_name + " is a crafting material and cannot be used directly. Use it in crafting recipes!")
