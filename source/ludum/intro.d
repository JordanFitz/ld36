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
    int opacity = 0;
    long _lastMsecs = 0;
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
         
         _logo.color = Color(255, 255, 255, cast(ubyte) opacity);

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

        long msecs = _timer.getElapsedTime().total!"msecs";

        if(opacity < 255 && _lastMsecs != msecs)
        {
            _lastMsecs = msecs;
            _logo.color = Color(255, 255, 255, cast(ubyte) ++opacity);
        }

        if(opacity >= 255)
        {
            msecs -= 255;

            if(msecs >= 3000)
            {
                _done = true;
                _callback();
            }
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
