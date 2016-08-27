module ludum.game;

import std.json: parseJSON;

import dsfml.graphics;

import ludum.intro;
import ludum.spritesheet;
import ludum.util;

private static enum GAME_STATE { INTRO, MENU };

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

    float _delta = 1.0f;
    GAME_STATE _state;

    void _handleEvent(Event event)
    {
        if(event.type == Event.EventType.Closed)
        {
            _sfWindow.close();
            return;
        }
    }

    void _update()
    {
        if(_state == GAME_STATE.INTRO)
        {
            _intro.update();
        }
    }

    void _render() 
    {
        if(_state == GAME_STATE.INTRO)
        {
            _intro.render();
        }
    }

    void _tick()
    {
        Event event;
        while(_sfWindow.pollEvent(event))
        {
            _handleEvent(event);
        }

        _sfWindow.clear();

        _update();
        _render();

        _delta = _clock.restart().total!"msecs" / 250.0f;

        _sfWindow.display();
    }

    void _introFinished()
    {
        _state = GAME_STATE.MENU;
    }

public static:
    /// Set up the window and being the game loop
    void initialize()
    {
        _sfWindow = new RenderWindow(
            VideoMode(1280, 720), "Ludum Dare",
            Window.Style.Close
        );

        _sfWindow.setFramerateLimit(60);

        _spritesheetTexture = Util.loadTexture("./res/spritesheet.png");
        _spritesheet = new Spritesheet(_spritesheetTexture);
        _spritesheet.fromJSON(parseJSON(import("spritesheet.json")));

        _state = GAME_STATE.INTRO;

        _clock = new Clock;
        _intro = new Intro;

        _intro.onDone = &_introFinished;

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