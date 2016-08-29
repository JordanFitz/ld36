module ludum.popup;

import dsfml.graphics: Vector2f, Mouse, Vector2i, IntRect, FloatRect, Color;

import ludum.game;
import ludum.animatedsprite;
import ludum.textobject;

import std.stdio: writeln;

public static enum POPUP_TYPE { NONE = -1, PC, VHS, ID };

/// A class to manage a draggable in game "window" with an exit button
class Popup
{
private:
    AnimatedSprite _sprite;
    Vector2f _position;
    Vector2f _initialPosition;
    POPUP_TYPE _type;

    bool _visible = false;

    Vector2i _mouseDownPosition;

    TextObject[] _text;
    AnimatedSprite[] _childSprites;

    void _update()
    {
        if(!_visible || (Game.currentWindow != POPUP_TYPE.NONE && Game.currentWindow != _type))
        {
            return;
        }

        Vector2i mouse = Mouse.getPosition(Game.sf);
        Vector2i relativeMouse = mouse - _position;

        IntRect exitButton = IntRect(cast(int) _sprite.rect.width - 57, 16, 42, 28);

        if(Mouse.isButtonPressed(Mouse.Button.Left) && exitButton.contains(relativeMouse))
        {
            if(_mouseDownPosition == Vector2i(-int.max, -int.max))
            {
                _visible = false;
            }
        }
        else
        {
            FloatRect sensitiveArea;

            if (_type == POPUP_TYPE.PC)
            {
                sensitiveArea = FloatRect(
                    _position.x, _position.y, 315, 55
                );
            }
            else
            {
                sensitiveArea = _sprite.rect;
            }

            if(sensitiveArea.contains(mouse) || _mouseDownPosition != Vector2i(-int.max, -int.max))
            {
                if(Mouse.isButtonPressed(Mouse.Button.Left))
                {
                    Game.currentWindow = _type;

                    if(_mouseDownPosition == Vector2i(-int.max, -int.max))
                    {
                        _mouseDownPosition = mouse;
                    }
                    else if(_mouseDownPosition != mouse)
                    {
                        _position = _initialPosition - (_mouseDownPosition - mouse);
                    }                    
                }
                else
                {
                    Game.currentWindow = POPUP_TYPE.NONE;
                    
                    _mouseDownPosition = Vector2i(-int.max, -int.max);
                    _initialPosition = _position;
                }
            }
            else
            {
                Game.currentWindow = POPUP_TYPE.NONE;
            }
        }

        if(_position.x < 0.0f)
        {
            _position = Vector2f(0.0f, _position.y);
        }

        if(_position.y < 0.0f)
        {
            _position = Vector2f(_position.x, 0.0f);
        }

        if(_position.x > Game.sf.getSize().x - _sprite.rect.width)
        {
            _position = Vector2f(Game.sf.getSize().x - _sprite.rect.width, _position.y);
        }

        if(_position.y > Game.sf.getSize().y - _sprite.rect.height)
        {
            _position = Vector2f(_position.x, Game.sf.getSize().y - _sprite.rect.height);
        }
    }

public:
    /**
     * Construct a new Popup
     * Params:
     *  type = the type of popup to construct
     *  position = the pixel position of the popup
     */
    this(POPUP_TYPE type, Vector2f position)
    {
        _type = type;
        _position = position;
        _initialPosition = position;

        _mouseDownPosition = Vector2i(-int.max, -int.max);

        switch(type)
        {
            case POPUP_TYPE.PC:
                _sprite = Game.spritesheet.getSprite("window_pc");
                break;

            case POPUP_TYPE.VHS:
                _sprite = Game.spritesheet.getSprite("window_vhs");
                break;

            case POPUP_TYPE.ID:
                _sprite = Game.spritesheet.getSprite("window_id");
                break;
            
            default: assert(0);
        }
    }

    /**
     * 
     */
    void setText(string[] lines)
    {
        _text = [];

        if(_type == POPUP_TYPE.ID)
        {
            _text ~= new TextObject("USA", Game.font, 20, Vector2f(155.0f, 68.0f));
            _text[$-1].color = Color(50, 50, 50);
        }

        foreach(i, line; lines)
        {
            Vector2f position = Vector2f(0.0f, 0.0f);

            if(_type == POPUP_TYPE.ID)
            {
                if(i == 0) 
                {
                    position = Vector2f(155.0f, 112.0f);
                }
                else if (i == 1)
                {
                    position = Vector2f(155.0f, 127.0f);
                }
                else
                {
                    position = Vector2f(155.0f, 168.0f);
                }
            }

            _text ~= new TextObject(line, Game.font, 20, position);
            _text[$-1].color = Color(50, 50, 50);
        }
    }

    /// Set the popup to visible
    void show()
    {
        _visible = true;
    }

    /// Render the window
    void render()
    {
        if(!_visible)
        {
            return;
        }

        _sprite.position = _position;
        _sprite.render();

        foreach(object; _text)
        {
            Vector2f tempPosition = object.position;

            object.position = _position + tempPosition;
            object.render(false);
            object.position = tempPosition;
        }
    }

    /// Update the window
    void update()
    {
        _update();
    }

    /// Public access to the popup's type
    @property
    POPUP_TYPE type()
    {
        return _type;
    }
}