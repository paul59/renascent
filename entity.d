

enum EntityType {human, rat, pig, bear, snake, ogre, butterfly}



struct Entity
{

    int locX;               // location x, y
    int locY;
    int facing;             // facing direction
    int hp;                 // hit points
    int sp;                 // soul points
    int att;                // attack
    int def;                // defense
    Creature entity;        // what type of creature

}



struct Creature
{
    
    string name;
    int basehp;
   
}



Creature[] creature =   [   {"Human", 25},
                            {"Rat", 3},
                            {"Pig", 14},
                            {"Bear", 32},
                            {"Snake", 11},
                            {"Ogre", 50},
                            {"Butterfly", 1}
                        ];
