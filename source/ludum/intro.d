module ludum.intro;

import std.stdio: writeln;

import dsfml.system: Clock;
import dsfml.graphics:
    Sprite,
    RectangleShape,
    Vector2f,
    Color;

import ludum.game;
import ludum.animatedsprite;

/// A class to manage the intro sequence, fading the logo in and out
class Intro
{
private:
    Clock _timer;
    RectangleShape _background;
    AnimatedSprite _logo;

    bool _done = false;

    void function() _callback;

public:
    /// Construct a new intro sequence
    this()
    {
         _background = new RectangleShape(
             Vector2f(Game.sf.getSize())
         );

         _background.fillColor = Color(53, 64, 115);

         _logo = Game.spritesheet.getSprite("logo");
         _logo.position = Vector2f(
             (_background.size / 2.0f) - Vector2f(125.0f, 125.0f)
         );
         
         _logo.color = Color(255, 255, 255, 0);

         _timer = new Clock;
         _timer.restart();
    }

    /// Update the opacity of the logo
    void update()
    {
        if(_done)
        {
            return;
        }

        const long msecs = _timer.getElapsedTime().total!"msecs";

        if(msecs < 2000)
        {
            if(_logo.color.a + 8 <= 255)
            {
                _logo.color = Color(255, 255, 255, cast(ubyte)(_logo.color.a + 8));
            }
            else
            {
                _logo.color = Color(255, 255, 255);
            }
        }

        if(msecs >= 5000)
        {
            _done = true;
            _callback();
        }
    }    

    /// Render the logo
    void render()
    {
        Game.sf.draw(_background);
        _logo.render();
    }

    /// The callback when the sequence finishes
    @property
    void onDone(void function() callback)
    {
        _callback = callback;
    }
}
