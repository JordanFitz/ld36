module ludum.clickablesprite;

import ludum.game;
import ludum.animatedsprite;

import dsfml.graphics: Vector2i, Mouse, Color;

/// A class to manage sprites that can be clicked on
class ClickableSprite
{
private:
    AnimatedSprite _sprite;

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
        _sprite.color = Color(225, 225, 225);

        Vector2i mouse = Mouse.getPosition(Game.sf);

        if(_sprite.rect.contains(mouse))
        {
            _sprite.color = Color(255, 255, 255);

            if(Mouse.isButtonPressed(Mouse.Button.Left))
            {
                _sprite.color = Color(200, 200, 200);
            }
        }
    }
}