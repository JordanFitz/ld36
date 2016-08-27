module ludum.game;

import dsfml.graphics;

/// The wrapper class to contain the SFML RenderWindow and
/// handle updates, rendering and events
static class Game
{
private static:
    RenderWindow _sfWindow;
    Clock _clock;

    float _delta = 1.0f;

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

    }

    void _render() 
    {

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

public static:
    /// Set up the window and being the game loop
    void initialize()
    {
        _clock = new Clock;

        _sfWindow = new RenderWindow(
            VideoMode(1280, 720), "Ludum Dare",
            Window.Style.Close
        );

        _sfWindow.setFramerateLimit(60);

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
}