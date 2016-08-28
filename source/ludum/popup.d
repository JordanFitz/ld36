module ludum.popup;

import dsfml.graphics: Vector2f, Mouse, Vector2i, IntRect;

import ludum.game;
import ludum.animatedsprite;

import std.stdio: writeln;

public static enum POPUP_TYPE { PC, VHS, ID };

/// A class to manage a draggable in game "window" with an exit button
class Popup
{
private:
    AnimatedSprite _sprite;
    Vector2f _position;
    Vector2f _initialPosition;
    POPUP_TYPE _type;

    bool _visible = true;

    Vector2i _mouseDownPosition;

    void _update()
    {
        Vector2i mouse = Mouse.getPosition(Game.sf);
        Vector2i relativeMouse = mouse - _position;
        IntRect exitButton = IntRect(cast(int) _sprite.rect.width - 57, 16, 42, 28);

        if(exitButton.contains(relativeMouse))
        {
            if(Mouse.isButtonPressed(Mouse.Button.Left))
            {
                _visible = false;
            }
        }
        else if (_type != POPUP_TYPE.PC)
        {
            if(_sprite.rect.contains(mouse))
            {
                if(Mouse.isButtonPressed(Mouse.Button.Left))
                {
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
                    _mouseDownPosition = Vector2i(-int.max, -int.max);
                    _initialPosition = _position;
                }
            }
        }
        else if (_type == POPUP_TYPE.PC)
        {
            IntRect windowChrome;
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

    /// Render the window
    void render()
    {
        if(!_visible)
        {
            return;
        }

        _update();

        _sprite.position = _position;
        _sprite.render();
    }
}