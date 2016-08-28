module ludum.animatedsprite;

import std.stdio: stderr;

import dsfml.graphics: 
	RenderWindow,
	Sprite,
	Texture,
	IntRect,
	FloatRect,
	Vector2f,
	Clock,
	Color;

import ludum.game;

/**
 * A class for managing multiple sf::Sprite frames to produce an animation
 */
class AnimatedSprite
{
private: 
	Sprite[] _frames;
	bool _running;
	int _interval;
	uint _currentFrame = 0;
	float _scale = 1.0f;
	Texture _texture;
	Clock _animationTimer;
	Vector2f _position;
	string _id;

public:
	/**
	 * Construct an AnimatedSprite and initialize its timer
	 * Params:
	 *  texture = sf::Texture to grab frames from
	 *  position = the pixel position of the sprite 
	 */
	this(string id, Texture texture, Vector2f position)
	{
		_id = id;
		_texture = texture;
		_position = position;

		_animationTimer = new Clock;
		_animationTimer.restart();
	}

	/**
	 * Construct an AnimatedSprite and initialize its timer
	 * Params:
	 *  texture = sf::Texture to grab frames from
	 *  position = the pixel position of the sprite
	 *  x = X position of the sprite's cropping
	 *  y = Y position of the sprite's cropping
	 *  width = width of the sprite's cropping
	 *  height = height of the sprite's cropping 
	 */
	this(string id, Texture texture, Vector2f position, int x, int y, int width, int height)
	{
		_id = id;
		_texture = texture;
		_position = position;

		addFrame(x, y, width, height);

		_animationTimer = new Clock;
		_animationTimer.restart();
	}

	/**
	 * Create a new sprite and crop it with the given measurements
	 * Params:
	 *  x = X position of the sprite's cropping
	 *  y = Y position of the sprite's cropping
	 *  width = width of the sprite's cropping
	 *  height = height of the sprite's cropping 
	 */
	void addFrame(int x, int y, int width, int height)
	{
		Sprite sprite = new Sprite(_texture);

		sprite.position = _position;
		sprite.textureRect = IntRect(x, y, width, height);

		_frames ~= sprite;
	}

	/// Start the animation
	void start()
	{
		_running = true;
	}

	/// Stop the animation
	void stop()
	{
		_running = false;
	}

	/**
	 * Update and render the current frame
	 * Params:
	 *  sf = the sf::RenderWindow to render the frame to
	 */
	void render()
	{
		if(_running && _animationTimer.getElapsedTime().total!"msecs" >= _interval)
		{
			_animationTimer.restart();
			_currentFrame++;

			if(_currentFrame > _frames.length - 1)
			{
				_currentFrame = 0;
			}
		}

		if(_frames.length == 0)
		{
			return;
		}

		Game.sf.draw(_frames[_currentFrame]);
	}

	/// The current frame
	@property
	{
		uint frame()
		{
			return _currentFrame;
		}

		uint frame(uint newFrame)
		{			
			_currentFrame = newFrame;
			return _currentFrame;
		}
	}

	/// The string ID of the sprite
	@property
	string id()
	{
		return _id;
	}

	/// The number of milliseconds to wait between changing animation frames
	@property
	{
		int interval()
		{
			return _interval;
		}

		int interval(int newInterval)
		{
			_interval = newInterval;
			return _interval;
		}
	}

	/// The pixel position of the sprite
	@property
	{
		Vector2f position()
		{
			if(_frames.length > 0)
			{
				return _frames[0].position;
			}

			stderr.writeln("Attempted to obtain the position of an AnimatedSprite with no frames!");
			return Vector2f(0, 0);
		}

		Vector2f position(Vector2f newPosition)
		{
			foreach(frame; _frames)
			{
				frame.position = newPosition;
			}

			if(_frames.length > 0)
			{
				return _frames[0].position;
			}

			stderr.writeln("Attempted to set the position of an AnimatedSprite with no frames!");
			return Vector2f(0, 0);
		}
	}

	/// The globalBounds of the sprite
	@property
	FloatRect rect()
	{
		if(_frames.length > 0)
		{
			return _frames[0].getGlobalBounds();
		}

		stderr.writeln("Attempted to call rect() on an AnimatedSprite with no frames!");
		return FloatRect(0, 0, 0, 0);
	}

	/// The scale of the sprite, X and Y scale are equal in all cases
	@property
	{
		float scale()
		{
			return _scale;
		}

		float scale(float newScale)
		{
			_scale = newScale;

			foreach(frame; _frames)
			{
				frame.scale = Vector2f(_scale, _scale);
			}

			return _scale;
		}
	}

	/// The rotation of the sprite
	@property
	{
		float rotation(float newRotation)
		{
			foreach(frame; _frames)
			{
				frame.rotation = newRotation;
			}

			return _frames[0].rotation;
		}

		float rotation()
		{
			return _frames[0].rotation;
		}
	}

	/// The origin of the sprite
	@property
	{
		Vector2f origin(Vector2f newOrigin)
		{
			foreach(frame; _frames)
			{
				frame.origin = newOrigin;
			}

			return _frames[0].origin;
		}

		Vector2f origin()
		{
			return _frames[0].origin;
		}
	}

	/// The sprite's color
	@property
	{
		Color color()
		{
			return _frames[0].color;
		}

		Color color(Color newColor)
		{
			foreach(frame; _frames)
			{
				frame.color = newColor;
			}

			return _frames[0].color;
		}
	}
}