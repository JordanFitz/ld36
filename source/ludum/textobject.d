module ludum.textobject;

import dsfml.graphics: 
	Vector2f,
	RenderWindow,
	Text,
	Color,
	Font
;

import ludum.game;

/// A class to wrap SFML's Text object, which is annoying to work with
class TextObject
{
private:
	Text _sfText;
	Color _color;
	Vector2f _position;
    uint _textSize;

public:
    /**
     * Construct a new TextObject
     * Params:
     *  content = the actual string
     *  font = the sf::Font to use
     *  size = the size of the text to render
     *  pos = the position of the TextObject
     */
	this(string content, Font font, uint size, Vector2f pos)
	{
		_sfText = new Text(content, font, size);

		position = pos;
        textSize = size;
	}

    /// The pixel size of the whole TextObject
	@property
	Vector2f size()
	{
		return Vector2f(_sfText.getGlobalBounds().width, _sfText.getGlobalBounds().height);
	}

    /// The text size
    @property
    {
        uint textSize()
        {
            return _sfText.getCharacterSize();
        }

        uint textSize(uint newTextSize)
        {
            _sfText.setCharacterSize(newTextSize);
            return newTextSize;
        }
    } 

    /// The pixel position of the TextObject
	@property
	{		
		Vector2f position()
		{
			return _position;
		}

		Vector2f position(Vector2f newPosition)
		{
			_position = _sfText.position = newPosition;
			return _position;
		}
	}

    /// The text color
	@property 
	{
		Color color(Color newColor)
		{
			_color = newColor;
			return _color;
		}

		Color color()
		{
			return _color;
		}
	}

    /// The actual string to render
	@property
	{
		string content(string newContent)
		{
			_sfText.setString(newContent);
			return newContent;
		}

		string content()
		{
			return _sfText.getString();
		}
	}

    /**
     * Render the text
     * Params:
     *  useLineHeight = whether or not to adjust the sf::Text on the Y axis
     *  useLineWidth = whether or not to adjust the sf::Text on the X axis
     */
	void render(bool useLineHeight = true, bool useLineWidth = true)
	{
		_sfText.position = Vector2f(0.0f, 0.0f);
		_sfText.setColor(Color.Transparent);

		Game.sf.draw(_sfText);

		_sfText.position = Vector2f(
			useLineWidth ? -_sfText.getGlobalBounds().left : 0,
			useLineHeight ? -_sfText.getGlobalBounds().top : 0
		) + _position;

		_sfText.setColor(_color);

		Game.sf.draw(_sfText);

		_sfText.position = _position;
	}
}