module ludum.costumer;

import std.random: uniform;
import std.format: format;

private static string[] _firstNames = ["Devin", "Moshe", "Hershel", "Arthur", "Wilmer", "Clyde", "Chet", "Roger", "Toby", "Porter", "Scottie", "Denis", "Neal", "Elbert", "Sebastian", "Chong", "Loren", "Dustin", "Jefferson", "Zachary", "Bruce", "Frederick", "Carrol", "Markus", "Jaime", "Billy","Rufus", "Michael", "Quentin", "Geoffrey", "Antony", "Vernon", "Cliff", "Brain", "Brent", "Adam", "Edgardo", "Hong", "Clifford", "Harris", "Eddy", "Johnny", "Rob", "Aurelio", "Kristofer", "Carlton", "Olen", "Kurt", "Abdul", "Steven"];
private static string[] _lastNames = ["Beyer", "Pound", "Beard", "Mangus", "Innes", "Lavigne", "Ploof", "Eckler", "Antley", "Seibert", "Schaefer", "Sharrock", "Horrigan", "Neiss", "Dople", "Meraz", "Valadez", "Tibbits", "Likes", "Anthony", "Silvestre", "Vert", "Quarles", "Shupe", "Baade", "Dykema","Buster", "Chapell", "Renna", "Weissinger", "Ramerez", "Rosato", "Godard", "Rogue", "Longacre", "Kadel", "Roach", "Costantino", "Newsome", "Moultrie", "Lent", "Litteral", "Spalding", "Bulluck", "Bain", "Danley", "Hallee", "Westbury", "Porcaro", "Moskowitz"];

private static string[12] _months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

/// A Mockbuster customer
class Customer
{
private:
    string _name;
    string _birth;

public:
    /// Construct a new customer
    this()
    {
        _name = format("%s %s", _firstNames[uniform(0, $)], _lastNames[uniform(0, $)]);

        const uint month = uniform(1, 13);
        const uint year = uniform(1916, 2007);
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

        _birth = format("%d %s %d", day, _months[month], year);
    }
}