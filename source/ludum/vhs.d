module ludum.vhs;

import std.random: uniform;
import std.format: format;

import dsfml.graphics: Vector2f, Color;

import ludum.animatedsprite;
import ludum.game;
import ludum.textobject;

private static
{
    enum RATING { E, R7, R13, R18, X }
    RATING[5] _ratings = [RATING.E, RATING.R7, RATING.R13, RATING.R18, RATING.X];
    string[] _titleParts = ["Man","Woman","Boy","Girl","Dame","Hunk","Punch","Action","Dance","Party","Bully","Cowboy","Alien","Indian","Massacre","Backdoor","Sexy","Bunny","Fun","Killer","Garden","School","Ninja","Policeman","Kick","Gun","Bullet","House","Mansion","Devil","God","Jesus","Satan","Lord","Smiley","Frog","Depression"];
}

///
class VHS
{
private:
    RATING _rating;
    string _titleA;
    string _titleB;
    TextObject _titleText;
    AnimatedSprite _ratingSprite;
    AnimatedSprite _coverSprite;

public:
    ///
    this()
    {
        _rating = _ratings[uniform(0,$)];

        string ratingSprite = "rating_";
        string coverSprite = "cover_";

        switch(_rating)
        {
            case RATING.E:
                ratingSprite ~= "e";
                coverSprite ~= "e";
                break;

            case RATING.R7:
                ratingSprite ~= "7";
                coverSprite ~= "7";
                break;
                
            case RATING.R13:
                ratingSprite ~= "13";
                coverSprite ~= "13";
                break;

            case RATING.R18:
                ratingSprite ~= "18";
                coverSprite ~= "18";
                break;

            case RATING.X:
                ratingSprite ~= "x";
                coverSprite ~= "x";
                break;
            
            default: assert(0);
        }

        _ratingSprite = Game.spritesheet.getSprite(ratingSprite);

        _titleA = _titleParts[uniform(0,$)];
        _titleB = _titleParts[uniform(0,$)];

        _titleText = new TextObject("", Game.font, 28, Vector2f(0,0));

        uint cover = uniform(1, 4);
        coverSprite ~= format("_%d", cover);
        _coverSprite = Game.spritesheet.getSprite(coverSprite);
    }

    ///
    void render(Vector2f position)
    {
        _ratingSprite.position = position + Vector2f(192.0f, 83.0f);
        _ratingSprite.render();

        _coverSprite.position = position + Vector2f(48,87);
        _coverSprite.render();

        _titleText.content = _titleA;
        _titleText.color = Color.Transparent;
        _titleText.render(false);
        _titleText.position = position + Vector2f(32, 20);
        _titleText.color = Color.White;
        _titleText.render(false);

        _titleText.content = _titleB;
        _titleText.color = Color.Transparent;
        _titleText.render(false);
        _titleText.position = position + Vector2f(32, 40);
        _titleText.color = Color.White;
        _titleText.render(false);
    }

    uint getRequiredAge()
    {
        switch(_rating)
        {
            case RATING.E: return 0;
            case RATING.R7: return 7;
            case RATING.R13: return 13;
            case RATING.R18: return 18;
            case RATING.X: return 21;
            default: assert(0);
        }
    }
}