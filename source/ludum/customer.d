module ludum.costumer;

import std.random: uniform;

private static string[] _firstNames = ["Devin", "Moshe", "Hershel", "Arthur", "Wilmer", "Clyde", "Chet", "Roger", "Toby", "Porter", "Scottie", "Denis", "Neal", "Elbert", "Sebastian", "Chong", "Loren", "Dustin", "Jefferson", "Zachary", "Bruce", "Frederick", "Carrol", "Markus", "Jaime", "Billy","Rufus", "Michael", "Quentin", "Geoffrey", "Antony", "Vernon", "Cliff", "Brain", "Brent", "Adam", "Edgardo", "Hong", "Clifford", "Harris", "Eddy", "Johnny", "Rob", "Aurelio", "Kristofer", "Carlton", "Olen", "Kurt", "Abdul", "Steven"];
private static string[] _lastNames = ["Beyer", "Pound", "Beard", "Mangus", "Innes", "Lavigne", "Ploof", "Eckler", "Antley", "Seibert", "Schaefer", "Sharrock", "Horrigan", "Neiss", "Dople", "Meraz", "Valadez", "Tibbits", "Likes", "Anthony", "Silvestre", "Vert", "Quarles", "Shupe", "Baade", "Dykema","Buster", "Chapell", "Renna", "Weissinger", "Ramerez", "Rosato", "Godard", "Rogue", "Longacre", "Kadel", "Roach", "Costantino", "Newsome", "Moultrie", "Lent", "Litteral", "Spalding", "Bulluck", "Bain", "Danley", "Hallee", "Westbury", "Porcaro", "Moskowitz"];

/// A Mockbuster customer
class Customer
{
private:
    string _name;

public:
    /// Construct a new customer
    this()
    {
        _name = _firstNames[uniform(0, $)] ~ " " ~ _lastNames[uniform(0, $)];
    }
}