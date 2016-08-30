module ludum.transition;

import std.format: format;

import dsfml.graphics: RectangleShape, Vector2f, Color, Clock;

import ludum.game;
import ludum.textobject;
import ludum.popup;

///
class Transition
{
private:
    RectangleShape _overlay;

    void function() _middle;

    TextObject _text;

    Clock _timer;

    bool _reachedMiddle = false;
    bool _running = false;

public:
    ///
    this()
    {
        _overlay = new RectangleShape(Vector2f(Game.sf.getSize()));
        _overlay.fillColor = Color(0, 0, 0, 0);
        _text = new TextObject("", Game.font, 50, Vector2f(0,0));
        _timer = new Clock;
    }

    ///
    void render()
    {  
        if(_running)
        {
            if(!_reachedMiddle && _overlay.fillColor.a + 8 < 255)
            {
                _overlay.fillColor = Color(0, 0, 0, cast(ubyte)(_overlay.fillColor.a + 8));
            }
            else if(!_reachedMiddle)
            {
                _overlay.fillColor = Color.Black;
                _reachedMiddle = true;
                _timer.restart();
                _middle();
            }
            else
            {
                if(_timer.getElapsedTime().total!"seconds" >= 2)
                {
                    _overlay.fillColor = Color.Transparent;
                    _running = false;
                }
            }
        }
        else
        {
            _overlay.fillColor = Color.Transparent;
        }

        Game.sf.draw(_overlay);

        _text.content = format("Day %d begins...", Popup.dayCycle.day);
        _text.color = Color.Transparent;
        _text.render();
        _text.color = Color(255, 255, 255, _overlay.fillColor.a);
        _text.position = Vector2f(Game.sf.getSize().x / 2 - _text.size.x / 2, Game.sf.getSize().y / 2 - _text.size.y / 2);
        _text.render();
    }

    ///
    void go()
    {
        _running = true;
    }

    @property
    void onMiddle(void function() callback)
    {
        _middle = callback;
    }
}