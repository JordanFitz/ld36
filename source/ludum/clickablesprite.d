module ludum.clickablesprite;

import ludum.game;
import ludum.animatedsprite;
import ludum.popup: POPUP_TYPE;

import dsfml.graphics: Vector2i, Mouse, Color;

/// A class to manage sprites that can be clicked on
class ClickableSprite
{
private:
    AnimatedSprite _sprite;
    bool _clicked = false;
    void function() _callback;

public:
    /**
     * Construct a new ClickableSprite
     * Params:
     *  sprite = the sprite that should be clickable
     */
    this(AnimatedSprite sprite)
    {
        _sprite = sprite;
    }

    /// Update the sprite
    void update()
    {
        if(Game.currentWindow != POPUP_TYPE.NONE)
        {
            return;
        }

        _sprite.color = Color(225, 225, 225, _sprite.color.a);

        Vector2i mouse = Mouse.getPosition(Game.sf);

        if(_sprite.rect.contains(mouse) && _sprite.color.a == 255)
        {
            _sprite.color = Color(255, 255, 255, _sprite.color.a);

            if(Mouse.isButtonPressed(Mouse.Button.Left))
            {
                if(!_clicked)
                {
                    _callback();
                }

                _sprite.color = Color(200, 200, 200, _sprite.color.a);
                _clicked = true;
            }
            else
            {
                _clicked = false;
            }
        }
    }

    /// The click callback
    @property
    void onClick(void function() callback)
    {
        _callback = callback;
    }
}