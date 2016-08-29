module ludum.popup;

import dsfml.graphics: Vector2f, Mouse, Vector2i, IntRect, FloatRect, Color;

import ludum.game;
import ludum.animatedsprite;
import ludum.textobject;
import ludum.daycycle;
import ludum.vhs;

import std.format: format;

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

    VHS _vhs;

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
    ///
    static DayCycle dayCycle = null;

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

        if(dayCycle is null)
        {
            dayCycle = new DayCycle;
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

    void setText(TextObject[] text)
    {
        _text = text;
    }

    /**
     *
     */
    void setChildSprites(AnimatedSprite[] children)
    {
        _childSprites = children;
    }

    /// Set the popup to visible
    void show()
    {
        _visible = true;
    }

    /// Set the popup to invisible
    void hide()
    {
        _visible = false;
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
            if(_type == POPUP_TYPE.PC) break;
            const Vector2f tempPosition = object.position;

            object.position = _position + tempPosition;
            object.render(false);
            object.position = tempPosition;
        }

        if(_type == POPUP_TYPE.ID)
        {
            foreach(child; _childSprites)
            {
                child.scale = 0.5f;
            }

            const Vector2f offset = Vector2f(33.0f, 58.0f);
            AnimatedSprite child = _childSprites[0];

            child.position = _position + offset + Vector2f((52.0f - child.rect.width / 2.0f), (70.0f - child.rect.height / 2.0f));
            child.render();

            for(uint i = 1; i < _childSprites.length; i++)
            {
                _childSprites[i].position = child.position;
                _childSprites[i].render();
            }
        }
        else if (_type == POPUP_TYPE.PC)
        {
            dayCycle.renderTime(_position + Vector2f(35.0f, 70.0f));

            TextObject goal = new TextObject(format("Goal: $%d.00", dayCycle.goal), Game.font, 27, Vector2f(0,0));
            goal.color = Color.Transparent;
            goal.render(false);
            goal.color = Color(0,213,34); 
            goal.position = _position + Vector2f(35.0f, 332 - 60 - goal.size.y);
            goal.render(false); 

            TextObject money = _text[0];

            money.color = Color.Transparent;
            money.render(false);
            money.color = Color(0,213,34); 
            money.position = _position + Vector2f(35.0f, 332 - 35 - money.size.y);
            money.render(false); 
        }
        else if(_type == POPUP_TYPE.VHS)
        {
            _vhs.render(_position);
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

    ///
    void setVHS(VHS vhs)
    {
        _vhs = vhs;
    }
}