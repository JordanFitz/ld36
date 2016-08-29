module ludum.fadingsprite;

import dsfml.graphics: Color;

import ludum.animatedsprite;

///
class FadingSprite
{
private:
    AnimatedSprite _sprite;
    uint _direction = 0;
    bool _running = false;

public:
    ///
    this(AnimatedSprite sprite)
    {
        _sprite = sprite;
        _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b, 0);
    }

    ///
    void update()
    {
        if(_running)
        {
            if(_direction == 0)
            {
                if(_sprite.color.a + 5 <= 255)
                {
                    _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b, cast(ubyte)(_sprite.color.a + 5));
                }
                else
                {
                    _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b);
                    _running = false;
                }
            }
            else
            {
                if(_sprite.color.a - 5 >= 0)
                {
                    _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b, cast(ubyte)(_sprite.color.a - 5));
                }
                else
                {
                    _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b, 0);
                    _running = false;
                }
            }
        }
    }

    ///
    void fadeIn()
    {
        _direction = 0;
        _running = true;
        _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b, 0);
    }

    ///
    void fadeOut()
    {
        _direction = 1;
        _running = true;
        _sprite.color = Color(_sprite.color.r, _sprite.color.g, _sprite.color.b);
    }
}