module ludum.game;

import std.json: parseJSON;

import dsfml.graphics;

import ludum.intro;
import ludum.spritesheet;
import ludum.util;
import ludum.textobject;
import ludum.bounce;

/// An indicator of whether or not the game was compiled in debug mode
public static const bool DEBUG_MODE = true;

private static enum GAME_STATE { INTRO, MENU, PLAY };

/// The wrapper class to contain the SFML RenderWindow and
/// handle updates, rendering and events
static class Game
{
private static:
    RenderWindow _sfWindow;
    Clock _clock;
    Intro _intro;
    Spritesheet _spritesheet;
    Texture _spritesheetTexture;
    Font _font;
    TextObject _infoText;

    bool _loaded = false;
    float _delta = 1.0f;
    GAME_STATE _state;

    void _handleEvent(Event event)
    {
        if(event.type == Event.EventType.Closed)
        {
            _sfWindow.close();
            return;
        }

        if(event.type == Event.EventType.KeyReleased)
        {
            if(_state == GAME_STATE.MENU)
            {
                _state = GAME_STATE.PLAY;
            }
        }
    }

    void _update()
    {
        if(!_loaded)
        {
            return;
        }

        if(_state == GAME_STATE.INTRO)
        {
            _intro.update();
        }
        else if(_state == GAME_STATE.MENU)
        {
            Bounce.update(_spritesheet.getSprite("title"));
        }
    }

    void _render() 
    {
        if(!_loaded)
        {
            _infoText.render();
            return;
        }

        if(_state == GAME_STATE.INTRO)
        {
            _intro.render();
        }
        else if (_state == GAME_STATE.MENU)
        {
            _spritesheet.getSprite("title").render();
            _infoText.render();
        }
        else if (_state == GAME_STATE.PLAY)
        {
            _spritesheet.getSprite("counter").render();
            _spritesheet.getSprite("pc").render();
        }
    }

    void _tick()
    {
        Event event;
        while(_sfWindow.pollEvent(event))
        {
            _handleEvent(event);
        }

        _sfWindow.clear(Color(53, 64, 115));

        _update();
        _render();

        _delta = _clock.restart().total!"msecs" / 250.0f;

        _sfWindow.display();
    }

    void _introFinished()
    {
        _state = GAME_STATE.MENU;

        _infoText.content = "Press any key to start";
        _infoText.textSize = 40;
        _infoText.color = Color(53, 64, 115);
        _infoText.render();
        _infoText.color = Color.White;

        _infoText.position = Vector2f(
            (_sfWindow.getSize().x / 2) - _infoText.size.x / 2,
            500.0f
        );
    }

public static:
    /// Set up the window and being the game loop
    void initialize()
    {
        _clock = new Clock;
        
        _sfWindow = new RenderWindow(
            VideoMode(1280, 720), "Mockbuster",
            Window.Style.Close
        );

        _sfWindow.setFramerateLimit(60);

        _font = Util.loadFont("./res/font.ttf");

        _infoText = new TextObject("Loading...", _font, 35, Vector2f(0,0));
        _infoText.render();
        _infoText.color = Color.White;

        _infoText.position = Vector2f(
            (_sfWindow.getSize() / 2) - _infoText.size / 2
        );

        _tick();

        _spritesheetTexture = Util.loadTexture("./res/spritesheet.png");
        _spritesheetTexture.setSmooth(true);

        _spritesheet = new Spritesheet(_spritesheetTexture);
        _spritesheet.fromJSON(parseJSON(import("spritesheet.json")));

        _state = GAME_STATE.INTRO;

        _intro = new Intro;
        _intro.onDone = &_introFinished;

        _loaded = true;

        static if(DEBUG_MODE)
        {
            _introFinished();
        }

        while(_sfWindow.isOpen())
        {
            _tick();
        }
    }

    /// Public access to the SFML RenderWindow
    @property
    RenderWindow sf()
    {
        return _sfWindow;
    }

    /// Public access to the Window's delta value
    @property
    float delta()
    {
        return _delta;
    }

    /// Public access to the main Spritesheet
    @property
    Spritesheet spritesheet()
    {
        return _spritesheet;
    }
}