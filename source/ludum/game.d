module ludum.game;

import std.json: parseJSON;
import std.stdio: writeln, write;

import dsfml.graphics;
import dsfml.audio: Sound;

import ludum.intro;
import ludum.spritesheet;
import ludum.util;
import ludum.textobject;
import ludum.bounce;
import ludum.clickablesprite;
import ludum.popup;
import ludum.customer;

/// An indicator of whether or not the game was compiled in debug mode
public static const bool DEBUG_MODE = false;

private static enum GAME_STATE { INTRO, MENU, PLAY };

/// The wrapper class to contain the SFML RenderWindow and
/// handle updates, rendering and events
static class Game
{
private static:
    Clock _clock;

    RenderWindow _sfWindow;
    Texture _spritesheetTexture;
    Font _font;
    Sound _cashRegisterSound;
    Sprite _background;

    Intro _intro;
    Spritesheet _spritesheet;
    TextObject _infoText;

    Popup _pcWindow;
    Popup _idWindow;
    Popup _vhsWindow;

    Popup[3] _windows;

    POPUP_TYPE _currentWindow = POPUP_TYPE.NONE;

    bool _windowOrderChanged = false;
    bool _loaded = false;
    bool _hasFocus = true;
    bool _overlayDrawn = false;
    float _delta = 1.0f;

    ClickableSprite[] _clickableSprites;

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

                _spritesheet.getSprite("title").scale = 0.5;
                _spritesheet.getSprite("title").position = Vector2f(94.25f, 50.0f);
            }
        }

        if(event.type == Event.EventType.LostFocus)
        {
            _hasFocus = false;
        }
        
        if(event.type == Event.EventType.GainedFocus)
        {
            _hasFocus = true;
        }
    }

    void _update()
    {
        if(!_loaded)
        {
            return;
        }

        _spritesheet.getSprite("cursor").position = Vector2f(Mouse.getPosition(_sfWindow));

        if(!_hasFocus)
        {
            return;
        }

        if(!Mouse.isButtonPressed(Mouse.Button.Left))
        {
            _currentWindow = POPUP_TYPE.NONE;
        }

        if(_windowOrderChanged)
        {
            _orderWindows();
            _windowOrderChanged = false;
        }

        if(_state == GAME_STATE.INTRO)
        {
            _intro.update();
        }
        else if(_state == GAME_STATE.MENU)
        {
            Bounce.update(_spritesheet.getSprite("title"));
        }
        else if (_state == GAME_STATE.PLAY)
        {
            for(int i = _windows.length - 1; i >= 0; i--)
            {
                _windows[i].update();
            }

            foreach(sprite; _clickableSprites)
            {
                sprite.update();
            }
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
            _sfWindow.draw(_background);

            _spritesheet.getSprite("title").render();
            _spritesheet.getSprite("counter").render();
            _spritesheet.getSprite("pc").render();
            _spritesheet.getSprite("cashregister").render();
            _spritesheet.getSprite("vhs").render();
            _spritesheet.getSprite("id").render();

            foreach(window; _windows)
            {
                window.render();
            }
        }

        if (!_hasFocus)
        {
            RectangleShape overlay = new RectangleShape(Vector2f(_sfWindow.getSize()));
            overlay.fillColor = Color(0, 0, 0, 200);
            _sfWindow.draw(overlay);
        }

        _spritesheet.getSprite("cursor").render();
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

    void _orderWindows()
    {
        if(_currentWindow == POPUP_TYPE.NONE)
        {
            return;
        }

        foreach(i, window; _windows)
        {
            if(window.type == _currentWindow)
            {
                Popup moveWindow = window;

                _windows[i] = null;

                for(uint j = i; j < _windows.length - 1; j++)
                {
                    _windows[j] = _windows[j + 1];
                }

                _windows[$ - 1] = moveWindow;

                break;
            }
        }
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

    void _pcClicked()
    {
        _pcWindow.show();
    }

    void _cashRegisterClicked()
    {
        auto cashRegister = _spritesheet.getSprite("cashregister");

        if(cashRegister.frame == 0)
        {
            cashRegister.frame = 1;
            cashRegister.position = cashRegister.position - Vector2f(28.0f, 0.0f);
            _cashRegisterSound.play();
        }
        else
        {
            cashRegister.frame = 0;
            cashRegister.position = cashRegister.position + Vector2f(28.0f, 0.0f);
        }
    }

    void _vhsClicked()
    {
        _vhsWindow.show();
    }

    void _idClicked()
    {
        _idWindow.show();
    }

public static:
    /// Set up the window and being the game loop
    void initialize()
    {
        _clock = new Clock;
        _background = new Sprite;
        
        _sfWindow = new RenderWindow(
            VideoMode(1280, 720), "Mockbuster",
            Window.Style.Close
        );

        _sfWindow.setFramerateLimit(60);
        _sfWindow.setMouseCursorVisible(false);

        _font = Util.loadFont("./res/font.ttf");
        _cashRegisterSound = Util.loadSound("./res/cashregister.wav");
        _background.setTexture(Util.loadTexture("./res/background.png"));

        _cashRegisterSound.volume = 20;

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

        _clickableSprites ~= new ClickableSprite(_spritesheet.getSprite("pc"));
        _clickableSprites[$ - 1].onClick = &_pcClicked;

        _clickableSprites ~= new ClickableSprite(_spritesheet.getSprite("cashregister"));
        _clickableSprites[$ - 1].onClick = &_cashRegisterClicked;

        _clickableSprites ~= new ClickableSprite(_spritesheet.getSprite("vhs"));
        _clickableSprites[$ - 1].onClick = &_vhsClicked;

        _clickableSprites ~= new ClickableSprite(_spritesheet.getSprite("id"));
        _clickableSprites[$ - 1].onClick = &_idClicked;

        _loaded = true;

        _pcWindow = new Popup(POPUP_TYPE.PC, Vector2f(825.0f, 100.0f));
        _vhsWindow = new Popup(POPUP_TYPE.VHS, Vector2f(475.0f, 250.0f));
        _idWindow = new Popup(POPUP_TYPE.ID, Vector2f(100.0f, 150.0f));

        _windows[0] = _pcWindow;
        _windows[1] = _vhsWindow;
        _windows[2] = _idWindow;

        Customer test = new Customer;
        _idWindow.setText([test.firstName, test.lastName, test.birth]);

        static if(DEBUG_MODE)
        {
            _introFinished();
            _state = GAME_STATE.PLAY;
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

    /// Public access to the indicator of which window is active
    @property
    {
        POPUP_TYPE currentWindow()
        {
            return _currentWindow;
        }

        POPUP_TYPE currentWindow(POPUP_TYPE newWindow)
        {
            _currentWindow = newWindow;
            _windowOrderChanged = true;
            return _currentWindow;
        }
    }

    /// Public access to the main font
    @property
    Font font()
    {
        return _font;
    }
}