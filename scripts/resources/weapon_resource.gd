extends Resource
class_name WeaponResource

## Base class for all weapons
## Weapons can be equipped and used in combat
## This class is extended by specialized weapon types like ProjectileWeaponResource

@export_group("Item Identity")
## Unique identifier for this weapon
@export var item_id: String = ""

## Display name for this weapon
@export var item_name: String = "Unknown Weapon"

## Description of this weapon
@export var description: String = ""

## Icon for this weapon
@export var icon: Texture2D

## Can this item be stacked?
@export var stackable: bool = false

## Maximum stack size if stackable
@export var max_stack_size: int = 1

## Item rarity (Common, Uncommon, Rare, Epic, Legendary)
@export var rarity: String = "Common"

## Gold value of this item
@export var value: int = 0

@export_group("Weapon Stats")
## Base damage dealt by this weapon
@export var base_damage: float = 10.0

## Time between attacks in seconds
@export var fire_rate: float = 1.0

## How far the weapon can reach or shoot
@export var range: float = 500.0

## Accuracy modifier (0.0 = perfect accuracy, higher = more spread)
@export var accuracy_spread: float = 0.0

@export_group("Carry Requirements")
## How much carry capacity this weapon requires
## Heavier weapons need higher carry capacity from leveling
@export var weight: int = 1

## Does this weapon occupy the dual-wield slot?
@export var requires_dual_wield: bool = false

@export_group("Weapon Visuals")
## The sprite/texture for this weapon when held
@export var weapon_sprite: Texture2D

## Offset position relative to player
@export var hold_offset: Vector2 = Vector2(20, 0)

## Should this weapon rotate to face the target direction?
@export var rotates_with_aim: bool = true


## Virtual method for when the weapon is fired/used
## Override in child classes to implement specific weapon behavior
func fire(shooter: Node2D, target_direction: Vector2) -> void:
	push_warning("fire() not implemented for " + item_name)


## Calculate actual damage based on player stats and weapon accuracy
func calculate_damage(player_accuracy_bonus: float) -> float:
	var base = base_damage
	# Future: Add player stat modifiers here
	return base


## Calculate actual fire rate based on weapon stats
func get_fire_cooldown() -> float:
	return fire_rate
