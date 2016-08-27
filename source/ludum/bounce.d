module ludum.bounce;

import std.stdio: writeln;

import dsfml.graphics: Vector2f;

import ludum.animatedsprite;

/// An indicator of which way a sprite is moving (up/down)
public static enum DIRECTION { UP, DOWN }

/// A class to give a sprite a bouncing effect
static class Bounce
{
private static:
    // float[string] _velocities;
    Vector2f[string] _initialPositions;
    DIRECTION[string] _directions;

public static:
    /**
     * Move the sprite
     */
    void update(AnimatedSprite sprite)
    {
        if(sprite.id !in _initialPositions)
        {
            _initialPositions[sprite.id] = sprite.position;
            _directions[sprite.id] = DIRECTION.DOWN;
        }

        const Vector2f difference = sprite.position - _initialPositions[sprite.id];
        const DIRECTION direction = _directions[sprite.id];

        if(direction == DIRECTION.DOWN && difference.y < 0.0f)
        {
            sprite.position = sprite.position + Vector2f(0.0f, 0.15f);
        }
        else if (direction == DIRECTION.DOWN && difference.y >= 0.0f)
        {
            _directions[sprite.id] = DIRECTION.UP;
        }
        else if (direction == DIRECTION.UP && difference.y > -5.0f)
        {
            sprite.position = sprite.position - Vector2f(0.0f, 0.15f);
        }
        else if (direction == DIRECTION.UP && difference.y <= -5.0f)
        {
            _directions[sprite.id] = DIRECTION.DOWN;
        }
    }
}