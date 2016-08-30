module ludum.clickablesprite;

import ludum.game;
import ludum.animatedsprite;
import ludum.popup: POPUP_TYPE;

import dsfml.graphics: Vector2i, Mouse, Color;

private void _nothing()
{

}

/// A class to manage sprites that can be clicked on
class ClickableSprite
{
private:
    AnimatedSprite _sprite;
    bool _clicked = false;
    bool _left = true;
    bool _hovered = false;

    void function() _callback;
    void function() _hover;
    void function() _leave;

public:
    /**
     * Construct a new ClickableSprite
     * Params:
     *  sprite = the sprite that should be clickable
     */
    this(AnimatedSprite sprite)
    {
        _sprite = sprite;
        onHover = &_nothing;
        onLeft = &_nothing;
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

            _left = false;

            if(!_hovered)
            {
                _hover();
                _hovered = true;
            }

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
        else
        {
            _hovered = false;

            if(!_left)
            {
                _left = true;
                _leave();
            }
        }
    }

    /// The click callback
    @property
    void onClick(void function() callback)
    {
        _callback = callback;
    }

    @property onHover(void function() callback)
    {
        _hover = callback;
    }

    @property onLeft(void function() callback)
    {
        _leave = callback;
    }
}