module ludum.spritesheet;

import std.stdio: stderr;
import std.json: JSONValue;

import dsfml.graphics: Texture, Vector2f;

import ludum.animatedsprite;
import ludum.util;

/**
 * A class used to manage AnimatedSprites and JSON spritesheets
 */
class Spritesheet
{
private:
	AnimatedSprite[string] _sprites;
	Texture _texture;

public:
	/**
	 * Construct a Spritesheet given an sf::Texture
	 * Params:
	 *  texture = the SFML Texture to use when createing AnimatedSprites
	 */
	this(Texture texture)
	{
		_texture = texture;
	}

	/**
	 * Add an existing AnimatedSprite to the sprites table
	 * Params:
	 *  id = the ID to assign the sprite to in the sprites table
	 *  sprite = the sprite itself to be added to the sprites table
	 */
	void addSprite(string id, AnimatedSprite sprite)
	{
		if(id in _sprites)
		{
			stderr.writeln("Attempted to create a sprite with an ID that's already in use!");
			return;
		}

		_sprites[id] = sprite;
	}

	/**
	 * Create a new sprite and add it to the sprites table
	 * Params:
	 *  id = the ID to assign the new sprite to in the sprites table
	 *  position = the coordinate position of the new sprite
	 *  x = the X position of the sprite's cropping
	 *  y = the Y position of the sprite's cropping
	 *  width = the width of the sprite's cropping
	 *  height = the height of the sprite's cropping
	 */
	void addSprite(string id, Vector2f position, int x, int y, int width, int height)
	{
		if(id in _sprites)
		{
			stderr.writeln("Attempted to create a sprite with an ID that's already in use!");
			return;
		}

		_sprites[id] = new AnimatedSprite(id, _texture, position, x, y, width, height);
	}

	/**
	 * Obtain a sprite using its ID, assuming it exists
	 * Params:
	 *  id = the ID of the desired sprite
	 * Returns: the AnimatedSprite from the sprites table
	 */
	AnimatedSprite getSprite(string id)
	{
		if(id in _sprites)
		{
			return _sprites[id];
		}

		stderr.writeln(`Nonexistent sprite "` ~ id ~ `"`);
		return null;
	}

	/**
	 * Load the spritesheet from JSON so that spritesheets don't have to be hard coded
	 * Params:
	 *  json = the JSON spritesheet itself
	 * Format:
	 *  id = string
	 *  scale = float
	 *  interval = int
	 *  position:
	 *    x = float
	 *    y = float
	 *  frames: array
	 *    x = float
	 *    y = float
	 *    width = float
	 *    height = float
	 */
	void fromJSON(JSONValue json)
	{
		Util.validateField(json, "sprites", "array");

		JSONValue[] spritesJSON = json["sprites"].array;
		foreach(spriteJSON; spritesJSON)
		{
			Util.validateField(spriteJSON, "id", "string");
			Util.validateField(spriteJSON, "scale", "float");
			Util.validateField(spriteJSON, "interval", "int");

			Util.validateField(spriteJSON, "position", "object");
			Util.validateField(spriteJSON, "frames", "array");

			float scale = spriteJSON["scale"].floating;

			JSONValue positionJSON = spriteJSON["position"];
			Util.validateField(positionJSON, "x", "float");
			Util.validateField(positionJSON, "y", "float");

			const Vector2f position = Vector2f(
				positionJSON["x"].floating,
				positionJSON["y"].floating
			);

			AnimatedSprite sprite = new AnimatedSprite(spriteJSON["id"].str, _texture, position);

			sprite.interval = cast(int) spriteJSON["interval"].integer;

			if(sprite.interval > 0)
			{
				sprite.start();
			}

			JSONValue[] framesJSON = spriteJSON["frames"].array;
			foreach(frame; framesJSON)
			{
				Util.validateField(frame, "x", "int");
				Util.validateField(frame, "y", "int");
				Util.validateField(frame, "width", "int");
				Util.validateField(frame, "height", "int");

				sprite.addFrame(
					cast(int) frame["x"].integer, 	  cast(int) frame["y"].integer,
					cast(int) frame["width"].integer, cast(int) frame["height"].integer
				);
			}

			sprite.scale = scale;

			addSprite(spriteJSON["id"].str, sprite);
		}
	}
}