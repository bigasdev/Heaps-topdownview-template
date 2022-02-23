# About
 A new template using the heaps.io lib created by deepnight games, it has new features and built-in stuff to help with my style of game development.

## New Features

* Built-in Inventory for the hero class;
* Built-in HP Bar for the entity class;
* Built-in Title Screen;
* Debug function for the game class (it only shows the trace if you are in debug mode and it automatically converts stuff to string using the Std.string);
* Built-in item class with a magnet function to the player;
* Added some usefull stuff to the tile.aseprite (medkit, hearts, diamonds, coins, etc..).
* Function to create enemies and items within the game class, this way they are stored in an array.

## Built-in Title Screen
Now we have the `Title.hx` which is called before the game starts, it has the functions to create texts/logo(image) and automatically fades away with an explosion sound when you click the `Press start to continue button` or hit space/enter

## Built-in Inventory
Now we have the `Inventory` class inside the Hero.hx with 4 functions:

 * getItem();
 * checkItems();
 * addItem();
 * removeItem();

Every function has a debug to make sure its working, and we'll use the name of the item to add/remove it.

## Built-in HP Bar
Now we have the `HpBar` class inside the Entity.hx with 3 functions:

 * damageBar();
 * showBar();
 * updateBar();

You can use the showbar in the update to show the hp bar in the entity, a new HpBar is created by default in the Enemy.hx, the hearts are automatically updated with the damageBar function.


## Credits

A huge thanks to [Deepnight Games](https://github.com/deepnight) for the creation of the deepnight lib for heaps.io, if you ends up using this template or just like heaps.io i really recommend you checking his amazing stuff.

