module ludum.customer;

import std.random: uniform;
import std.format: format;
import std.json: parseJSON;

import dsfml.graphics: Vector2f, Texture;

import ludum.animatedsprite;
import ludum.game;
import ludum.spritesheet;
import ludum.util;
import ludum.vhs;

private static
{
    string[] _firstNames = ["Devin", "Moshe", "Hershel", "Arthur", "Wilmer", "Clyde", "Chet", "Roger", "Toby", "Porter", "Scottie", "Denis", "Neal", "Elbert", "Sebastian", "Chong", "Loren", "Dustin", "Jefferson", "Zachary", "Bruce", "Frederick", "Carrol", "Markus", "Jaime", "Billy","Rufus", "Michael", "Quentin", "Geoffrey", "Antony", "Vernon", "Cliff", "Brain", "Brent", "Adam", "Edgardo", "Hong", "Clifford", "Harris", "Eddy", "Johnny", "Rob", "Aurelio", "Kristofer", "Carlton", "Olen", "Kurt", "Abdul", "Steven"];
    string[] _lastNames = ["Beyer", "Pound", "Beard", "Mangus", "Innes", "Lavigne", "Ploof", "Eckler", "Antley", "Seibert", "Schaefer", "Sharrock", "Horrigan", "Neiss", "Dople", "Meraz", "Valadez", "Tibbits", "Likes", "Anthony", "Silvestre", "Vert", "Quarles", "Shupe", "Baade", "Dykema","Buster", "Chapell", "Renna", "Weissinger", "Ramerez", "Rosato", "Godard", "Rogue", "Longacre", "Kadel", "Roach", "Costantino", "Newsome", "Moultrie", "Lent", "Litteral", "Spalding", "Bulluck", "Bain", "Danley", "Hallee", "Westbury", "Porcaro", "Moskowitz"];
    string[12] _months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
}

/// A Mockbuster customer
class Customer
{
private:
    string _firstName;
    string _lastName;
    string _birth;

    uint _birthYear;

    AnimatedSprite[] _face;

    bool _walking = false;
    bool _reachedCounter = false;

    void function() _onReachedCounter;
    void function() _onFinished;

    static Spritesheet _faceFeatures = null;

    VHS _vhs;

public:
    /// Construct a new customer
    this()
    {
        if(_faceFeatures is null)
        {
            _faceFeatures = new Spritesheet(Util.loadTexture("./res/features.png"));
            _faceFeatures.fromJSON(parseJSON(import("face_features.json")));
        }

        _firstName = _firstNames[uniform(0, $)];
        _lastName = _lastNames[uniform(0, $)];

        const uint month = uniform(1, 13);
        const uint year = uniform(1920, 1981);
        
        uint day;

        if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
        {
            day = uniform(1, 32);
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11)
        {
            day = uniform(1, 31);
        }
        else if (month == 2)
        {
            if(year % 4 == 0)
            {
                day = 29;
            }
            else
            {
                day = 28;
            }
        }

        _birth = format("%d", year);
        _birthYear = year;

        if(uniform(0, 10) == 0)
        {
            const uint eyes = uniform(2, 8);
            _face ~= _faceFeatures.getSprite(format("eyes_%d", eyes));
        }
        else
        {
            _face ~= _faceFeatures.getSprite("eyes_1");
        }

        if(uniform(0, 5) == 0)
        {
            const uint feature = uniform(1, 7);
            _face ~= _faceFeatures.getSprite(format("feature_%d", feature));
        }

        const uint mouth = uniform(1, 11);
        _face ~= _faceFeatures.getSprite(format("mouth_%d", mouth));

        Game.spritesheet.getSprite("body").position = Vector2f(-200.0f, 400.0f);
        Game.spritesheet.getSprite("head").position = Vector2f(-208.0f, 245.0f);

        _vhs = new VHS;
    }

    /// Move the sprites if the customer is walking
    void update()
    {
        if(_walking)
        {
            const Vector2f amount = Vector2f(2.5f, 0.0f);

            Game.spritesheet.getSprite("body").position =
                Game.spritesheet.getSprite("body").position + amount;

            foreach(feature; _face)
            {
                feature.position = feature.position + amount;
            }

            const Vector2f bodyPosition = Game.spritesheet.getSprite("body").position;

            if(!_reachedCounter)
            {
                if(bodyPosition.x >= 572)
                {
                    Game.spritesheet.getSprite("body").position = Vector2f(572.0f, 400.0f);
                    Game.spritesheet.getSprite("head").position = Vector2f(564.0f, 245.0f);

                    _reachedCounter = true;
                    _walking = false;
                    _onReachedCounter();
                }
            }
            else
            {
                if(bodyPosition.x > Game.sf.getSize().x + 50.0f)
                {
                    _walking = false;
                    _onFinished();
                }
            }
        }
    }

    /// Render the customer and his features
    void render()
    {
        Game.spritesheet.getSprite("head").scale = 1.0f;

        Game.spritesheet.getSprite("head").position = 
            Game.spritesheet.getSprite("body").position - Vector2f(8.0f, 155.0f);

        Game.spritesheet.getSprite("body").render();
        Game.spritesheet.getSprite("head").render();

        foreach(feature; _face)
        {
            feature.position = Game.spritesheet.getSprite("head").position;
            feature.scale = 1.0f;
            feature.render();
        }
    }

    /// Tell the customer to walk in
    void walk()
    {
        _walking = true;
    }

    /// Public access to the customer's first name
    @property
    string firstName()
    {
        return _firstName;
    }

    /// Public access to the customer's last name
    @property lastName()
    {
        return _lastName;
    }

    /// Public access to the customer's birth date
    @property
    string birth()
    {
        return _birth;
    }

    /// Set the callback for when the customer reaches the counter
    @property
    void onReachedCounter(void function() callback)
    {
        _onReachedCounter = callback;
    }

    /// Set the callback for when the customer leaves
    @property
    void onFinished(void function() callback)
    {
        _onFinished = callback;
    }

    /// Public access to the customer's facial features
    @property
    AnimatedSprite[] face()
    {
        return _face;
    }

    ///
    @property
    VHS vhs()
    {
        return _vhs;
    }

    ///
    uint getAge()
    {
        return 1985 - _birthYear;
    }
}