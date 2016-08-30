module ludum.daycycle;

import std.format: format;
import std.math: floor;

import dsfml.graphics: Clock, Vector2f, Color;

import ludum.game;
import ludum.textobject;

///
class DayCycle
{
private:
    Clock _timer;
    uint _day = 1;
    TextObject _text;

    void function() _dayEnded;

    uint _moneyGoal;

public:
    ///
    this()
    {
        _text = new TextObject("", Game.font, 27, Vector2f(0.0f, 0.0f));
        _timer = new Clock;
        _timer.restart();
        _moneyGoal = 50;
    }

    ///
    string getTime()
    {
        // const long hours = _timer.getElapsedTime().total!"minutes";
        // long minutes = _timer.getElapsedTime().total!"seconds" * 2;
        long minutes = cast(long) floor(_timer.getElapsedTime().total!"msecs" / 500.0f);
        long hours = cast(long) floor(minutes / 60.0f);

        minutes = minutes >= 60 ? cast(long)(minutes - (floor(minutes / 60.0f) * 60)) : minutes; 

        if(hours == 8)
        {
            _day++;
            _dayEnded();
        }

        string result = format("%d:%02d", 9 + hours, minutes);

        return result;
    }

    ///
    void startDay()
    {
        _timer.restart();
        _moneyGoal += 10;
    }

    ///
    void renderTime(Vector2f position)
    {
        _text.content = getTime();
        _text.color = Color.Transparent;
        _text.render(false);

        _text.position = position + Vector2f(0.0f, 28.0f);

        _text.color = Color(0,213,34);
        _text.render(false);

        _text.content = format("Day %d, 1985", _day);
        _text.color = Color.Transparent;
        _text.render(false);

        _text.position = position;

        _text.color = Color(0,213,34);
        _text.render(false);
    }

    ///
    @property
    void onDayEnded(void function() callback)
    {
        _dayEnded = callback;
    }

    /// 
    @property
    uint goal()
    {
        return _moneyGoal;
    }

    @property
    uint day()
    {
        return _day;
    }
}